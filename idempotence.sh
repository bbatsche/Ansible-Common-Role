#!/bin/sh

set -e

ansible-playbook travis-playbook.yml --syntax-check

# Play test
bundle exec rake ansible:playbook:$ENVIRONMENT_NAME[travis-playbook.yml]

# Idempotence test
bundle exec rake ansible:playbook:$ENVIRONMENT_NAME[travis-playbook.yml] > idempotence.out

grep -q "changed=0.*failed=0" idempotence.out \
  && (echo "Idempotence test: pass" && exit 0) || (echo "Idempotence test: fail" && cat idempotence.out && exit 1);

