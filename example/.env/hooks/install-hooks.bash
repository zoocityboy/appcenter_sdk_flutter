#!/usr/bin/env bash

GIT_DIR=$(git rev-parse --git-dir)
echo "Installing hooks..."
cp -r $(pwd)/.env/hooks/pre-commit.bash $(pwd)/$GIT_DIR/hooks/pre-commit
cp -r $(pwd)/.env/hooks/pre-push.bash $(pwd)/$GIT_DIR/hooks/pre-push