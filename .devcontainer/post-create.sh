#!/usr/bin/env bash
# Configure persistent shell history for bash and zsh.
# The /commandhistory directory is backed by a named volume declared in
# devcontainer.json, so history survives container rebuilds.
set -euo pipefail

HISTORY_DIR="/commandhistory"
sudo mkdir -p "${HISTORY_DIR}"
sudo chown -R "$(id -u):$(id -g)" "${HISTORY_DIR}"

BASH_HISTFILE="${HISTORY_DIR}/.bash_history"
ZSH_HISTFILE="${HISTORY_DIR}/.zsh_history"
touch "${BASH_HISTFILE}" "${ZSH_HISTFILE}"

SNIPPET_MARKER="# >>> devcontainer persistent history >>>"
END_MARKER="# <<< devcontainer persistent history <<<"

append_snippet() {
	local rc_file="$1"
	local histfile="$2"
	touch "${rc_file}"
	if ! grep -qF "${SNIPPET_MARKER}" "${rc_file}"; then
		cat >> "${rc_file}" <<EOF

${SNIPPET_MARKER}
export HISTFILE="${histfile}"
export HISTSIZE=100000
export SAVEHIST=100000
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a; \${PROMPT_COMMAND:-}"
${END_MARKER}
EOF
	fi
}

append_snippet "${HOME}/.bashrc" "${BASH_HISTFILE}"
append_snippet "${HOME}/.zshrc"  "${ZSH_HISTFILE}"
