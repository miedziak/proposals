
js: clean
	mkdir -p .build/js
	kaitai-struct-compiler --target "javascript" --outdir .build/js ockam_wire/ockam_wire.ksy
	cd .build/js && npm install kaitai-struct
	cp test.js .build/js/
	cd .build/js && node test.js

clean:
	rm -rf .build
