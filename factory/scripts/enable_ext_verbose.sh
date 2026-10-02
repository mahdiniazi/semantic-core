#!/bin/bash
# فعال‌سازی logging مفصل برای افزونه‌ها
SETTINGS=~/.config/Code/User/settings.json
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
node -e "
const fs=require('fs');
const p=process.env.HOME+'/.config/Code/User/settings.json';
const j=JSON.parse(fs.readFileSync(p,'utf8'));
j['extensions.verboseLogging']=true;
j['extensions.experimental.affinity']={};
fs.writeFileSync(p,JSON.stringify(j,null,2));
console.log('settings updated');
"
cat ~/.config/Code/User/settings.json
