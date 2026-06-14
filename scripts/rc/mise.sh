if [[ $- == *i* ]] && command -v mise &> /dev/null; then
	echo 'eval "$(mise activate bash)"' >> ~/.bashrc
fi
