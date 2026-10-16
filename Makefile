# WICit documentation repo.
# Run these targets from the repo root. Each application folder is a standalone
# project meant to be opened separately in an IDE.

FRONTEND_DIR := wicit
BACKEND_DIR  := api-wicit-java

# Windows always uses cmd.exe so recipes behave the same whether or not a POSIX
# sh is on PATH; Linux/macOS use the default sh.
ifeq ($(OS),Windows_NT)
SHELL        := cmd.exe
GRADLE       := .\gradlew.bat
else
GRADLE       := ./gradlew
endif

# $(info) strips leading spaces, so help lines indent with this.
EMPTY  :=
INDENT := $(EMPTY)  $(EMPTY)

.DEFAULT_GOAL := help
.PHONY: help install build test clean \
	frontend frontend-install frontend-build frontend-preview frontend-test \
	backend backend-build backend-test backend-clean docs

help:
	$(info Usage: make <target>)
	$(info )
	$(info Frontend ($(FRONTEND_DIR), Vite + pnpm))
	$(info $(INDENT)frontend           Install deps and start the dev server)
	$(info $(INDENT)frontend-install   Install deps)
	$(info $(INDENT)frontend-build     Production build)
	$(info $(INDENT)frontend-preview   Preview the production build)
	$(info $(INDENT)frontend-test      Run tests (vitest))
	$(info )
	$(info Backend ($(BACKEND_DIR), Spring Boot + Gradle))
	$(info $(INDENT)backend            Run the API (bootRun))
	$(info $(INDENT)backend-build      Build the API)
	$(info $(INDENT)backend-test       Run tests)
	$(info $(INDENT)backend-clean      Remove build output)
	$(info $(INDENT)docs               Build the docs site with Javadoc)
	$(info )
	$(info All)
	$(info $(INDENT)install            Install frontend deps)
	$(info $(INDENT)build              Build frontend and backend)
	$(info $(INDENT)test               Test frontend and backend)
	$(info $(INDENT)clean              Clean backend build output)
	@cd .

# Frontend

frontend: frontend-install
	cd $(FRONTEND_DIR) && pnpm run dev

frontend-install:
	cd $(FRONTEND_DIR) && pnpm install

frontend-build: frontend-install
	cd $(FRONTEND_DIR) && pnpm run build

frontend-preview: frontend-build
	cd $(FRONTEND_DIR) && pnpm run preview

frontend-test: frontend-install
	cd $(FRONTEND_DIR) && pnpm run test --run

# Backend

backend:
	cd $(BACKEND_DIR) && $(GRADLE) bootRun

backend-build:
	cd $(BACKEND_DIR) && $(GRADLE) build -x test

backend-test:
	cd $(BACKEND_DIR) && $(GRADLE) test

backend-clean:
	cd $(BACKEND_DIR) && $(GRADLE) clean

docs:
	cd $(BACKEND_DIR) && $(GRADLE) docsSite

# All

install: frontend-install

build: frontend-build backend-build

test: frontend-test backend-test

clean: backend-clean
