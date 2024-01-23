STRIP          = $(shell command -v strip)
BINDERTMP          = $(TMPDIR)/Binder
BINDER_STAGE_DIR   = $(BINDERTMP)/stage
BINDER_APP_DIR     = $(BINDERTMP)/Build/Products/Release/Binder.app

.PHONY: package

check_dependencies:
	@command -v create-dmg >/dev/null 2>&1 || { echo >&2 "create-dmg is not installed. Aborting."; exit 1; }

package: check_dependencies
	# Build
	@set -o pipefail; \
		xcodebuild -jobs $(shell sysctl -n hw.ncpu) -project 'Binder.xcodeproj' -scheme Binder -configuration Release -sdk macosx -derivedDataPath $(BINDERTMP) \
		DSTROOT=$(BINDERTMP)/install ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO
	
	@rm -rf $(BINDER_STAGE_DIR)/
	@mkdir -p $(BINDER_STAGE_DIR)/Payload
	@mv $(BINDER_APP_DIR) $(BINDER_STAGE_DIR)/Payload/Binder.app

	# Package
	@echo $(BINDERTMP)      
	@rm -rf packages

	# Move new app bundle to package directory
	@mkdir packages
	@mv $(BINDER_STAGE_DIR)/Payload/Binder.app packages/Binder.app
	@rm -rf $(BINDERTMP)
	@rm -rf Payload
	@codesign -f -s - packages/Binder.app --preserve-metadata=entitlements
	
	# Make DMG
	@rm -rf packages/*.dmg
	@create-dmg --overwrite --identity=0 packages/Binder.app packages
