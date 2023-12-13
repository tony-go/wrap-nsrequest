PROJECT_DIR := $(CURDIR)
BUILD_DIR := $(PROJECT_DIR)/build

default: all

configure:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Xcode $(PROJECT_DIR)

all: configure
	cd $(BUILD_DIR) && cmake --build . --config Debug

clean:
	rm -rf $(BUILD_DIR)

run: $(BUILD_DIR)/Debug/cocoa_stream
	$(BUILD_DIR)/Debug/cocoa_stream

.PHONY: default configure all clean run

