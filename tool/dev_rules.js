// Validation and scoring rules for the dev server (see docs/api_design.md).
const NICKNAME = /^[A-Za-z0-9_.-]{3,20}$/;
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const BASE_POINTS = { word: 10, phrase: 20, sentence: 30 };
const SEGMENTS = ['school', 'academic', 'ielts', 'gre', 'spokenEnglish'];
const LEVELS = ['nursery', 'kg', 'class1', 'class2', 'class3', 'class4', 'class5',
  'class6', 'class7', 'class8', 'class9', 'class10', 'hsc', 'university', 'ielts',
  'gre', 'spokenEnglish'];
function validateProfile(body) {
  if (typeof body.displayName !== 'string' || !NICKNAME.test(body.displayName)) {
    return ['invalid_display_name', 'Nickname must be 3-20 letters, numbers, _ . or -'];
  }
  if (body.confirmedAge13Plus !== true) {
    return ['age_not_confirmed', 'You must be 13 or older to create an account.'];
  }
  if (body.leaderboardVisible !== undefined && typeof body.leaderboardVisible !== 'boolean') {
    return ['invalid_leaderboard_visible', 'leaderboardVisible must be true or false.'];
  }
  const area = body.upazilaId;
  if (area !== undefined && area !== null && !Number.isInteger(area)) {
    return ['invalid_upazila', 'upazilaId must be a number.'];
  }
  return null;
}

const isCount = (n, min = 0) => Number.isInteger(n) && n >= min;

function validateItem(item) {
  const ok = item && typeof item.questionId === 'string' && item.type in BASE_POINTS &&
    isCount(item.attempts, 1) && typeof item.correct === 'boolean' &&
    typeof item.revealed === 'boolean' && isCount(item.timeMs) && isCount(item.typedChars);
  return ok ? null : ['invalid_item', 'Every item needs questionId, type, attempts, correct, revealed, timeMs and typedChars.'];
}

function validateSession(body) {
  if (typeof body.clientSessionId !== 'string' || !UUID.test(body.clientSessionId)) {
    return ['invalid_session_id', 'clientSessionId must be a UUID.'];
  }
  if (body.segment === 'kids') return ['kids_not_ranked', 'Kids practice is never uploaded.'];
  if (!SEGMENTS.includes(body.segment) || !LEVELS.includes(body.level)) {
    return ['invalid_segment_or_level', 'Unknown segment or level.'];
  }
  const started = Date.parse(body.startedAt);
  const finished = Date.parse(body.finishedAt);
  if (Number.isNaN(started) || Number.isNaN(finished) || finished < started ||
      finished - started > 2 * 60 * 60 * 1000 || finished > Date.now() + 5 * 60 * 1000) {
    return ['invalid_times', 'startedAt and finishedAt are not a believable session.'];
  }
  const items = body.items;
  if (!Array.isArray(items) || items.length < 1 || items.length > 200) {
    return ['invalid_items', 'A session needs 1 to 200 items.'];
  }
  for (const item of items) {
    const problem = validateItem(item);
    if (problem) return problem;
  }
  if (new Set(items.map((i) => i.questionId)).size !== items.length) {
    return ['duplicate_question', 'A question appears twice in the session.'];
  }
  const chars = items.reduce((sum, i) => sum + i.typedChars, 0);
  const ms = items.reduce((sum, i) => sum + i.timeMs, 0);
  if (chars > 0 && ms / chars < 25) return ['implausible_session', 'That is faster than a person can type.'];
  return null;
}

const scoreItem = (i) =>
  i.correct && !i.revealed ? Math.round(BASE_POINTS[i.type] * Math.max(0.4, 1 - 0.2 * (i.attempts - 1))) : 0;

module.exports = { BASE_POINTS, validateProfile, validateSession, scoreItem };
