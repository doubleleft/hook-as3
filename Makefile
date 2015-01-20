default: build

build:
	compc -source-path . -output bin/hook.swc -include-classes com.doubleleft.hook.Client
