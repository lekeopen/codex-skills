#!/usr/bin/env node
import fs from 'node:fs/promises';

const source = process.argv[2];

if (!source) {
  console.error('Usage: node inspect_rss.mjs <rss-url-or-file>');
  process.exit(2);
}

async function readSource(input) {
  if (/^https?:\/\//i.test(input)) {
    const response = await fetch(input);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status} while fetching ${input}`);
    }
    return response.text();
  }
  return fs.readFile(input, 'utf8');
}

function tagValue(xml, tag) {
  const match = xml.match(new RegExp(`<${tag}(?:\\s[^>]*)?>([\\s\\S]*?)<\\/${tag}>`, 'i'));
  if (!match) return '';
  return match[1].replace(/^<!\[CDATA\[/, '').replace(/\]\]>$/, '').trim();
}

function attrValue(xml, tag, attr) {
  const match = xml.match(new RegExp(`<${tag}[^>]*\\s${attr}=["']([^"']+)["'][^>]*>`, 'i'));
  return match ? match[1].trim() : '';
}

function parseItems(xml) {
  const matches = [...xml.matchAll(/<item(?:\s[^>]*)?>([\s\S]*?)<\/item>/gi)];
  return matches.map((match) => {
    const itemXml = match[1];
    return {
      title: tagValue(itemXml, 'title'),
      link: tagValue(itemXml, 'link'),
      guid: tagValue(itemXml, 'guid'),
      pubDate: tagValue(itemXml, 'pubDate'),
      description: tagValue(itemXml, 'description'),
      enclosure: attrValue(itemXml, 'enclosure', 'url'),
    };
  });
}

function isValidDate(value) {
  return value && !Number.isNaN(new Date(value).getTime());
}

function summarize(items) {
  const problems = [];
  const seenGuids = new Set();

  items.forEach((item, index) => {
    const label = `item ${index + 1}`;
    if (!item.title) problems.push(`${label}: missing title`);
    if (!item.link) problems.push(`${label}: missing link`);
    if (!item.guid) problems.push(`${label}: missing guid`);
    if (item.guid && seenGuids.has(item.guid)) problems.push(`${label}: duplicate guid`);
    if (item.guid) seenGuids.add(item.guid);
    if (!isValidDate(item.pubDate)) problems.push(`${label}: invalid or missing pubDate`);
    if (!item.description) problems.push(`${label}: missing description`);
  });

  return problems;
}

try {
  const xml = await readSource(source);
  const items = parseItems(xml);
  const problems = summarize(items);

  console.log(`RSS source: ${source}`);
  console.log(`Items: ${items.length}`);
  console.log(`Ready for Make: ${items.length > 0 && problems.length === 0 ? 'yes' : 'check needed'}`);

  console.log('\nLatest items:');
  items.slice(0, 10).forEach((item, index) => {
    console.log(`${index + 1}. ${item.title || '(missing title)'}`);
    console.log(`   link: ${item.link || '(missing)'}`);
    console.log(`   guid: ${item.guid || '(missing)'}`);
    console.log(`   pubDate: ${item.pubDate || '(missing)'}`);
  });

  if (problems.length) {
    console.log('\nProblems:');
    problems.forEach((problem) => console.log(`- ${problem}`));
    process.exitCode = 1;
  }
} catch (error) {
  console.error(`RSS inspection failed: ${error.message}`);
  process.exit(1);
}
