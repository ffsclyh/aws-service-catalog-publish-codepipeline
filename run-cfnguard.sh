#!/bin/bash
shopt -s nullglob
mkdir -p templates/
cp {ec2,vpc}/*.{json,yml} templates/
cp codepipeline/*.json templates/


for f in templates/*; do
    
    if ./cfn-guard-linux/cfn-guard check -t "$f" -r ./cfnguard_rules/security_rules.ruleset ; then
        echo "$f PASSED"
    else
        echo "$f FAILED"
        touch FAILED
    fi
done

if [ -e FAILED ]; then
  echo cfn-guard FAILED at least once!
  exit 1
else
  echo cfn-guard PASSED on all files!
  exit 0
fi
