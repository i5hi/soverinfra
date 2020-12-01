#!/usr/bin/expect -f

set timeout -1

cd ../moltres/src/test

#spawn read -p "Are you sure? " -n 1 -r
spawn ts-node delete_collections.ts
expect {
  "true" {exp_continue}
  "false" {puts "FAIL"; exit}
}

spawn npm test
# expect {
#   "50 passing" {puts "WINNING!\n Ready to execute: ./update_server.sh <commit_name> <git_pass> <ansible_become_pass>"; exit}
#   "failing" {puts "FAIL"; exit}
# }

expect eof
