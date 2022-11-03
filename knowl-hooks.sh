#!/bin/sh
echo "Hello World"
python ../cli/main.py review-linked-not-updated-snippets
python ../cli/main.py review-linked-updated-snippets
