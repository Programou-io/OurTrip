_swiftlint:
	@echo "🧹 Running SwiftLint..."
	@swiftlint --fix && swiftlint
	@if [ $$? -ne 0 ]; then \
		echo "❌ SwiftLint validation failed."; \
		exit 1; \
	fi

_frontend:
	@make -C apps/frontend build

_backend:
	@make -C apps/backend build

build: _swiftlint _frontend _backend
	@echo "✅ Build completed successfully."

.PHONY: _swiftlint _build _frontend _backend
