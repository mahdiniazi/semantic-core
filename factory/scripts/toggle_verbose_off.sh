#!/bin/bash
# خاموش کردن verbose logging (پاک‌سازی)
SETTINGS=~/.config/Code/User/settings.json
node -e "
const fs=require('fs');
const p=process.env.HOME+'/.config/Code/User/settings.json';
try {
  const j=JSON.parse(fs.readFileSync(p,'utf8'));
  delete j['extensions.verboseLogging'];
  delete j['extensions.experimental.affinity'];
  fs.writeFileSync(p,JSON.stringify(j,null,2));
  console.log('cleaned');
} catch(e) { console.log('error:', e.message); }
"
cat ~/.config/Code/User/settings.json
