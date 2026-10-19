#!/usr/bin/env node
// Tiny in-memory stand-in for the English Practice API (development only).
//
// Implements /v1/me, /v1/me/stats, /v1/sessions and /v1/leaderboard (global
// scope only) so the app's sign-in, nickname, session upload and rankings can
// be tested with real 404 / 409 / 422 answers. It does NOT check tokens: any
// "Authorization: Bearer ..." header is accepted. Data is lost on restart.
//
//   node tool/dev_server.js            (port 4010, or set PORT)
const http = require('http');
const store = require('./dev_store');

const PORT = Number(process.env.PORT || 4010);

function userId(token) {
  try {
    const payload = JSON.parse(
      Buffer.from(token.split('.')[1], 'base64url').toString('utf8'),
    );
    return payload.user_id || payload.sub || token;
  } catch {
    return token;
  }
}

function send(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(body === undefined ? '' : JSON.stringify(body));
  return status;
}

const problem = (res, status, code, message) =>
  send(res, status, { code, message });

function readJson(req) {
  return new Promise((resolve) => {
    let raw = '';
    req.on('data', (chunk) => (raw += chunk));
    req.on('end', () => {
      try {
        resolve(raw ? JSON.parse(raw) : {});
      } catch {
        resolve(null);
      }
    });
  });
}

async function handleMe(req, res, uid) {
  const { profiles } = store;

  if (req.method === 'GET') {
    const profile = profiles.get(uid);
    return profile
      ? send(res, 200, profile)
      : problem(res, 404, 'profile_not_found', 'No profile yet.');
  }
  if (req.method === 'DELETE') {
    profiles.delete(uid);
    return send(res, 204);
  }
  if (req.method === 'PUT') {
    const body = await readJson(req);
    if (body === null) return problem(res, 422, 'invalid_json', 'Body is not valid JSON.');

    const invalid = store.validateProfile(body);
    if (invalid) return problem(res, 422, invalid[0], invalid[1]);
    if (store.nicknameTaken(body.displayName, uid)) {
      return problem(res, 409, 'nickname_taken', 'That nickname is already taken.');
    }
    const old = profiles.get(uid);
    const profile = {
      displayName: body.displayName,
      upazilaId: body.upazilaId ?? null,
      leaderboardVisible: body.leaderboardVisible ?? true,
      createdAt: old ? old.createdAt : new Date().toISOString(),
    };
    profiles.set(uid, profile);
    return send(res, 200, profile);
  }
  return problem(res, 405, 'method_not_allowed', 'Method not allowed.');
}

async function handleSessions(req, res, uid) {
  if (req.method !== 'POST') return problem(res, 405, 'method_not_allowed', 'Method not allowed.');

  const body = await readJson(req);
  if (body === null) return problem(res, 422, 'invalid_json', 'Body is not valid JSON.');
  if (!store.profiles.has(uid)) {
    return problem(res, 422, 'profile_required', 'Create a profile before uploading sessions.');
  }
  const invalid = store.validateSession(body);
  if (invalid) return problem(res, 422, invalid[0], invalid[1]);

  const saved = store.recordSession(uid, body);
  if (saved.owner !== uid) {
    return problem(res, 409, 'session_id_conflict', 'That session id belongs to someone else.');
  }
  return send(res, saved.duplicate ? 200 : 201, saved.result);
}

function handleLeaderboard(url, res, uid) {
  const query = url.searchParams;
  const period = query.get('period') || 'weekly';
  if (!(period in store.PERIOD_DAYS)) {
    return problem(res, 422, 'invalid_period', 'period must be weekly, monthly or allTime.');
  }
  if ((query.get('scope') || 'global') !== 'global') {
    return problem(res, 422, 'scope_not_supported', 'The dev server only has the global scope.');
  }
  const limit = Math.min(Math.max(Number(query.get('limit')) || 50, 1), 100);
  const page = store.leaderboard({
    period, uid, limit, segment: query.get('segment'), level: query.get('level'),
  });
  return send(res, 200, page);
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const path = url.pathname;
  const match = /^Bearer\s+(.+)$/.exec(req.headers.authorization || '');
  const uid = match ? userId(match[1]) : null;
  const needsSignIn = (handler) =>
    uid ? handler() : problem(res, 401, 'unauthorized', 'Sign in first.');
  let status;

  if (path === '/health') {
    status = send(res, 200, { ok: true });
  } else if (path === '/v1/me') {
    status = await needsSignIn(() => handleMe(req, res, uid));
  } else if (path === '/v1/me/stats') {
    status = await needsSignIn(() => send(res, 200, store.statsFor(uid)));
  } else if (path === '/v1/sessions') {
    status = await needsSignIn(() => handleSessions(req, res, uid));
  } else if (path === '/v1/leaderboard') {
    status = handleLeaderboard(url, res, uid); // sign-in is optional here
  } else {
    status = problem(res, 404, 'not_implemented', 'Not implemented in the dev server.');
  }
  console.log(`${req.method} ${path} -> ${status}`);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Dev API on http://0.0.0.0:${PORT}  (health: /health)`);
});
