#!/usr/bin/env node
import fs from 'node:fs/promises';

const file = process.argv[2] || 'publish-queue.json';

function normalizeChannels(value) {
  return Array.isArray(value) ? value : [];
}

try {
  const queue = JSON.parse(await fs.readFile(file, 'utf8'));
  const items = Array.isArray(queue.items) ? queue.items : [];
  const slugs = new Set();
  const problems = [];
  const platformCounts = new Map();

  items.forEach((item, index) => {
    const label = item.slug || `item ${index + 1}`;
    if (!item.slug) problems.push(`${label}: missing slug`);
    if (item.slug && slugs.has(item.slug)) problems.push(`${label}: duplicate slug`);
    if (item.slug) slugs.add(item.slug);
    if (!item.title) problems.push(`${label}: missing title`);
    if (!item.date) problems.push(`${label}: missing date`);
    if (!item.status) problems.push(`${label}: missing status`);

    const channels = normalizeChannels(item.channels);
    if (!channels.length) problems.push(`${label}: missing channels`);
    channels.forEach((channel) => {
      platformCounts.set(channel, (platformCounts.get(channel) || 0) + 1);
    });
  });

  const pending = items.filter((item) => item.status === 'pending');

  console.log(`Publish queue: ${file}`);
  console.log(`Generated at: ${queue.generatedAt || '(missing)'}`);
  console.log(`Items: ${items.length}`);
  console.log(`Pending: ${pending.length}`);
  console.log('\nChannels:');
  [...platformCounts.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .forEach(([channel, count]) => console.log(`- ${channel}: ${count}`));

  if (problems.length) {
    console.log('\nProblems:');
    problems.forEach((problem) => console.log(`- ${problem}`));
    process.exitCode = 1;
  }
} catch (error) {
  console.error(`Publish queue inspection failed: ${error.message}`);
  process.exit(1);
}
