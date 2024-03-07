
.PHONY: rebuild
rebuild:
	home-manager switch \
		&& git add . \
		&& git commit -m update \
		&& git push

.PHONY: update
update:
	nix-channel --update

.PHONE: fmt
fmt:
	nix fmt
