
.PHONY: rebuild
rebuild:
	home-manager switch \
		&& git add . \
		&& git commit -m update \
		&& git push
