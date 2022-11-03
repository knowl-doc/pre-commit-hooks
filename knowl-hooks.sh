#!/bin/sh
cd ../cli/
echo "Hello World"
python main.py review-linked-not-updated-snippets
python main.py review-linked-updated-snippets
