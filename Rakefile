# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks
task :rubocop do
  sh "rubocop --format simple || true"
end

#task default: [:rubocop]
