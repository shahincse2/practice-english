// In-memory data and aggregates for the dev server (see docs/api_design.md).
// Everything here is lost when the server restarts.
const rules = require('./dev_rules');

const DAY = 24 * 60 * 60 * 1000;
const PERIOD_DAYS = { weekly: 7, monthly: 30, allTime: Infinity };

const profiles = new Map(); // uid -> profile
const sessions = new Map(); // clientSessionId -> stored session

function nicknameTaken(name, uid) {
  const wanted = name.toLowerCase();
  return [...profiles].some(([other, p]) => other !== uid && p.displayName.toLowerCase() === wanted);
}

const round1 = (n) => Math.round(n * 10) / 10;

function streakDays(uid) {
  const days = new Set([...sessions.values()].filter((s) => s.uid === uid).map((s) => Math.floor(s.finishedMs / DAY)));
  let day = Math.floor(Date.now() / DAY);
  if (!days.has(day)) day -= 1; // a streak survives until the end of tomorrow
  let streak = 0;
  while (days.has(day)) { streak += 1; day -= 1; }
  return streak;
}

function statsFor(uid) {
  const mine = [...sessions.values()].filter((s) => s.uid === uid);
  const sum = (key) => mine.reduce((total, s) => total + s[key], 0);
  const attempts = sum('attempts');
  const correct = sum('correct');
  const minutes = sum('durationMs') / 60000;
  const learned = new Set(mine.flatMap((s) => s.learnedWords));
  return {
    sessionsCompleted: mine.length,
    wordsLearned: learned.size,
    attempts,
    correct,
    wrong: attempts - correct,
    accuracy: attempts ? round1((correct / attempts) * 100) : 0,
    averageWpm: minutes ? round1(sum('typedChars') / 5 / minutes) : 0,
    streakDays: streakDays(uid),
    points: sum('points'),
  };
}

function recordSession(uid, body) {
  const known = sessions.get(body.clientSessionId);
  if (known) return { duplicate: true, owner: known.uid, result: known.result };

  const items = body.items;
  const attempts = items.reduce((sum, i) => sum + i.attempts, 0);
  const correct = items.filter((i) => i.correct).length;
  const durationMs = items.reduce((sum, i) => sum + i.timeMs, 0);
  const typedChars = items.reduce((sum, i) => sum + i.typedChars, 0);
  const stored = {
    uid, attempts, correct, durationMs, typedChars,
    points: items.reduce((sum, i) => sum + rules.scoreItem(i), 0),
    finishedMs: Date.parse(body.finishedAt),
    segment: body.segment, level: body.level,
    learnedWords: items.filter((i) => i.type === 'word' && i.correct && !i.revealed).map((i) => i.questionId),
  };
  sessions.set(body.clientSessionId, stored);
  stored.result = {
    sessionId: body.clientSessionId,
    points: stored.points,
    correct,
    wrong: attempts - correct,
    accuracy: round1((correct / attempts) * 100),
    wpm: durationMs ? round1(typedChars / 5 / (durationMs / 60000)) : 0,
    stats: statsFor(uid),
  };
  return { duplicate: false, owner: uid, result: stored.result };
}

function leaderboard({ period, uid, limit, segment, level }) {
  const since = Date.now() - PERIOD_DAYS[period] * DAY;
  const totals = new Map();
  for (const s of sessions.values()) {
    if (s.finishedMs < since || (segment && s.segment !== segment) || (level && s.level !== level)) continue;
    totals.set(s.uid, (totals.get(s.uid) || 0) + s.points);
  }
  const ranked = [...totals]
    .filter(([id]) => profiles.get(id)?.leaderboardVisible)
    .map(([id, points]) => ({ id, points, name: profiles.get(id).displayName }))
    .sort((a, b) => b.points - a.points || a.name.localeCompare(b.name))
    .map((row, index) => ({
      rank: index + 1, displayName: row.name, points: row.points,
      streakDays: streakDays(row.id), isCurrentUser: row.id === uid,
    }));
  return {
    period, scope: 'global', entries: ranked.slice(0, limit),
    me: ranked.find((entry) => entry.isCurrentUser) || null, nextCursor: null,
  };
}

module.exports = {
  PERIOD_DAYS, profiles, nicknameTaken, recordSession, statsFor, leaderboard,
  validateProfile: rules.validateProfile,
  validateSession: rules.validateSession,
};
