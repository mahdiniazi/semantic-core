#!/bin/bash
for P in semantic-core workshop-manager; do
  ~/semantic_core/factory/scripts/mirror_review.sh "$P" > /dev/null 2>&1
done
echo "weekly mirror done: $(date '+%Y-%m-%d %H:%M')"
