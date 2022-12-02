#!/usr/bin/env bash

set -euo pipefail

help() {
  echo "Usage: $0 -v version -f fakeItEasyDir -b branchName"
  exit "$1"
}

while getopts "v:w:f:b:" opt; do
  case "$opt" in
    v) version="$OPTARG" ;;
    f) fakeItEasyDir="$OPTARG" ;;
    b) branchName="$OPTARG" ;;
    h) help 1 ;;
    ?) help 1 ;;
  esac
done

if [[ -z "$version" ]]; then
  echo "Missing version"
  help 1
fi

if [[ -z "$fakeItEasyDir" ]]; then
  echo "Missing FakeItEasy directory"
  help 1
fi

if [[ -z "$branchName" ]]; then
  echo "Missing branch name"
  help 1
fi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

pip install -r "$fakeItEasyDir/docs/requirements.txt"

cd `dirname $0`
git branch $branchName
mike deploy "$version" --branch "$branchName" --prefix docs --config-file "$fakeItEasyDir/mkdocs.yml"