#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/janet-lang/janet"
GH_REPO_JPM="https://github.com/janet-lang/jpm"
TOOL_NAME="janet"
TOOL_TEST="janet -v"
JPM_TAG=${JPM_TAG:-master}

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if janet is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"
  if [ "$ASDF_INSTALL_TYPE" = "version" ]; then
    version="v${version}"
  fi

  url="$GH_REPO/archive/${version}.tar.gz"

  echo "* Downloading $TOOL_NAME $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"
  local tool_cmd
  tool_cmd="${install_path}/bin/$(echo "$TOOL_TEST" | cut -d' ' -f1)"
  local git_hash
  if [ "$ASDF_INSTALL_TYPE" = "version" ]; then
    git_hash="meson"
  else
    git_hash="$ASDF_INSTALL_VERSION"
  fi

  (
    mkdir -p "$install_path"
    pushd "$ASDF_DOWNLOAD_PATH"
    meson setup build \
      --buildtype release \
      --optimization 2 \
      --prefix "$install_path" \
      --libdir "${install_path}/lib" \
      -Dgit_hash="$git_hash"
    ninja -C build
    ninja -C build install
    if [ -n "$JPM_TAG" ]; then
      local jpm_url="${GH_REPO_JPM}/archive/${JPM_TAG}.tar.gz"
      mkdir "${ASDF_DOWNLOAD_PATH}/jpm"
      curl "${curl_opts[@]}" "$jpm_url" | tar -C "${ASDF_DOWNLOAD_PATH}/jpm" -xzf - --strip-components=1 ||
        fail "Could not extract JPM archive"
      pushd "${ASDF_DOWNLOAD_PATH}/jpm"
      PREFIX="$install_path" "$tool_cmd" bootstrap.janet
      popd
    fi
    popd

    test -x "$tool_cmd" || fail "Expected $tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
