import {readFileSync, existsSync} from 'node:fs';
const required=['frontend/index.html','frontend/auth/login.html','frontend/citizen/citizen-map.html','frontend/admin/admin-dashboard.html','frontend/js/api.js'];
for(const path of required){if(!existsSync(path))throw new Error(`Missing ${path}`)}
const api=readFileSync('frontend/js/api.js','utf8'); if(!api.includes('Authorization'))throw new Error('API client does not attach authentication');
console.log('Static frontend smoke checks passed');
