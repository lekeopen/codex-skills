#!/usr/bin/env node
const args = process.argv.slice(2);

function readOption(name, fallback = '') {
  const index = args.indexOf(`--${name}`);
  if (index === -1) return fallback;
  return args[index + 1] || fallback;
}

const site = readOption('site', 'https://example.com');
const rss = readOption('rss', `${site.replace(/\/$/, '')}/rss.xml`);
const platforms = readOption('platforms', 'facebook,linkedin,x')
  .split(',')
  .map((item) => item.trim())
  .filter(Boolean);
const platformSteps = platforms
  .map((platform, index) => `${index + 5}. Add route for \`${platform}\`.`)
  .join('\n');
const scheduleStepNumber = platforms.length + 5;
const saveStepNumber = platforms.length + 6;

console.log(`# Social Distribution Setup Notes

Site: ${site}
RSS: ${rss}
Platforms: ${platforms.join(', ')}

## Make Scenario

1. Add \`RSS > Watch RSS feed items\`.
2. Set RSS URL to \`${rss}\`.
3. Set \`Maximum number of returned items\` to \`10\`.
4. Add a Router.
${platformSteps}
${scheduleStepNumber}. Set schedule to \`Every 1 day\`.
${saveStepNumber}. Save the scenario and verify Make credits are available.

## Default Post Template

\`\`\`text
{{title}}

{{description}}

Read more: {{link}}
\`\`\`

## Verification

- Deployed RSS contains the latest article.
- Make history shows scheduled runs.
- Destination platform shows the post or Buffer shows it in history.
`);
