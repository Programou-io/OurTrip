build:
	@echo "::BACK-END:: 🔨 Building backend..."
	docker-compose up -d
	swift run App migrate
	@echo "::BACK-END:: ✅ Backend was builded...."