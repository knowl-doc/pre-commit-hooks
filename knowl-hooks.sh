#!/bin/sh
cd ../cli/
echo "Hello World"
python https://github.com/knowl-doc/pre-commit-hooks/main1.py review-linked-not-updated-snippets
python https://github.com/knowl-doc/pre-commit-hooks/main1.py review-linked-updated-snippets
