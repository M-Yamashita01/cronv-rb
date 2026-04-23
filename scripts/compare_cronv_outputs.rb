#!/usr/bin/env ruby
# frozen_string_literal: true

# Compares the HTML outputs of OSS cronv (Go) and cronv-rb (Ruby) to verify
# that job names and color/time ranges match.
#
# Usage:
#   ruby scripts/compare_cronv_outputs.rb <oss_cronv.html> <cronvrb.html>

def usage
  "Usage: #{$PROGRAM_NAME} <oss_cronv.html> <cronvrb.html>"
end

abort usage if ARGV.length != 2

oss_path, rb_path = ARGV

abort "File not found: #{oss_path}" unless File.exist?(oss_path)
abort "File not found: #{rb_path}" unless File.exist?(rb_path)

# Parse the "Extra" section (e.g. @reboot entries) from the HTML.
# Returns an array of { label:, job: } hashes.
def parse_extras(html)
  extras = []
  html.scan(%r{<dt[^>]*>(.*?)</dt>\s*<dd[^>]*>(.*?)</dd>}m) do |label, command|
    extras << { label: label.strip, job: command.strip }
  end
  extras
end

# Normalize a new Date(...) string by removing all spaces after commas/parens
# so that "new Date(2025, 0, 1, 0, 5)" == "new Date(2025,0,1,0,5)".
def normalize_date(str)
  str.gsub(/\s+/, '')
end

# Parse all job names that are initialized in the JS block (tasks['job'] = ...).
# Returns a Set of job name strings.
def parse_all_job_names(html)
  jobs = Set.new
  html.scan(/tasks\['(.+?)'\]\s*=\s*tasks\[/) { |m| jobs << m[0] }
  jobs
end

# Parse timeline task entries from the JS block in the HTML.
# Returns a hash: { job_name => [{start:, end:}, ...] }
def parse_timeline(html)
  timeline = Hash.new { |h, k| h[k] = [] }

  html.scan(/tasks\['(.+?)'\]\.push\(\['(?:.+?)', '', '(?:.+?)', (new Date\(.+?\)), (new Date\(.+?\))\]\);/) do |job, start_date, end_date|
    timeline[job] << { start: normalize_date(start_date), end: normalize_date(end_date) }
  end

  timeline
end

puts 'Comparing:'
puts "  OSS cronv : #{oss_path}"
puts "  cronv-rb  : #{rb_path}"
puts

oss_html = File.read(oss_path)
rb_html  = File.read(rb_path)

errors = []

# ── 1. Compare Extras (e.g. @reboot) ─────────────────────────────────────────
oss_extras = parse_extras(oss_html)
rb_extras  = parse_extras(rb_html)

if oss_extras != rb_extras
  errors << 'Extra section mismatch:'
  errors << "  OSS cronv : #{oss_extras.inspect}"
  errors << "  cronv-rb  : #{rb_extras.inspect}"
else
  puts "[OK] Extras match (#{oss_extras.size} entries)"
end

# ── 2. Compare full job name set (including jobs with no executions) ───────────
oss_all_jobs = parse_all_job_names(oss_html)
rb_all_jobs  = parse_all_job_names(rb_html)

only_in_oss_all = oss_all_jobs - rb_all_jobs
only_in_rb_all  = rb_all_jobs  - oss_all_jobs

if only_in_oss_all.any?
  errors << 'Jobs present in OSS cronv but missing from cronv-rb:'
  only_in_oss_all.sort.each { |j| errors << "  - #{j}" }
end

if only_in_rb_all.any?
  errors << 'Jobs present in cronv-rb but missing from OSS cronv:'
  only_in_rb_all.sort.each { |j| errors << "  - #{j}" }
end

puts "[OK] Job names match (#{oss_all_jobs.size} jobs)" if only_in_oss_all.empty? && only_in_rb_all.empty?

# ── 3. Compare time ranges for jobs that have executions ─────────────────────
oss_timeline = parse_timeline(oss_html)
rb_timeline  = parse_timeline(rb_html)

common_jobs = oss_all_jobs & rb_all_jobs
range_errors = []

common_jobs.sort.each do |job|
  oss_entries = oss_timeline[job].sort_by { |e| e[:start] }
  rb_entries  = rb_timeline[job].sort_by  { |e| e[:start] }

  next if oss_entries == rb_entries

  range_errors << "  Job: #{job}"
  range_errors << "    OSS cronv count : #{oss_entries.size}"
  range_errors << "    cronv-rb  count : #{rb_entries.size}"

  # Show up to 3 differing entries
  diffs = oss_entries.zip(rb_entries).reject { |a, b| a == b }.first(3)
  diffs.each_with_index do |(oss_e, rb_e), i|
    range_errors << "    Diff ##{i + 1}:"
    range_errors << "      OSS: #{oss_e.inspect}"
    range_errors << "      RB : #{rb_e.inspect}"
  end
end

if range_errors.empty?
  puts "[OK] Time ranges match for all #{common_jobs.size} jobs"
else
  errors << 'Time range mismatches:'
  errors.concat(range_errors)
end

# ── Result ────────────────────────────────────────────────────────────────────
puts
if errors.empty?
  puts 'All checks passed. cronv-rb output matches OSS cronv.'
  exit 0
else
  puts 'FAILED: Differences found between OSS cronv and cronv-rb:'
  errors.each { |e| puts e }
  exit 1
end
