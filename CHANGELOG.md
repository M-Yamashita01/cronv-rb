# Changelog

## [0.3.0](https://github.com/M-Yamashita01/cronv-rb/compare/v0.2.0...v0.3.0) (2026-10-10)


### Features

* add Renovate configuration for automated dependency updates ([e5fa8a5](https://github.com/M-Yamashita01/cronv-rb/commit/e5fa8a526ac262d16f03c36def2f6be5a985a648))


### Bug Fixes

* gate RubyGems publish on manifest-mode releases_created output ([bdad7f8](https://github.com/M-Yamashita01/cronv-rb/commit/bdad7f88140959fe72e691e6f146be670b205256))
* gate RubyGems publish on manifest-mode releases_created output ([8c7c5ac](https://github.com/M-Yamashita01/cronv-rb/commit/8c7c5acd06ae9c8a256598f0a5af964f30b6ed24))
* loosen bundler dev dependency to &gt;= 2.5 for Bundler 4 ([ce315d8](https://github.com/M-Yamashita01/cronv-rb/commit/ce315d814340fdc3efc65dec3536b3709d5a5b82))
* stop tracking Gemfile.lock so releases do not break CI ([7c04564](https://github.com/M-Yamashita01/cronv-rb/commit/7c0456460193dc4ba1ebd833d94c813e0d1d10d7))

## [0.2.0](https://github.com/M-Yamashita01/cronv-rb/compare/v0.1.0...v0.2.0) (2026-10-06)


### Features

* add --version flag to CLI ([2cf5276](https://github.com/M-Yamashita01/cronv-rb/commit/2cf52767136a82b8b69d3744720e617d95849764))
* add --version flag to CLI ([41ca87f](https://github.com/M-Yamashita01/cronv-rb/commit/41ca87f1973c2e3fcecf2e2e7f5264c517e51feb)), closes [#32](https://github.com/M-Yamashita01/cronv-rb/issues/32)
* add CI workflow to compare cronv-rb output against OSS cronv ([af3d94f](https://github.com/M-Yamashita01/cronv-rb/commit/af3d94f86de2b1496a6c248c92a2e7b16465a138))
* add CI workflow to compare cronv-rb output against OSS cronv ([4c3ceca](https://github.com/M-Yamashita01/cronv-rb/commit/4c3ceca045c11726d032ad57e73c05840dc82ad6))
* add Renovate configuration ([6ebee84](https://github.com/M-Yamashita01/cronv-rb/commit/6ebee84ed62088b016a1e233a829169705c63a5e))
* add Renovate configuration for automated dependency updates ([3f9e637](https://github.com/M-Yamashita01/cronv-rb/commit/3f9e63720019819915daa371981f734630f23bea))
* add Renovate configuration for automated dependency updates ([6223087](https://github.com/M-Yamashita01/cronv-rb/commit/62230878cb08f26f85a1589beee93b6dbe050852))
* add Renovate configuration for automated dependency updates ([8cee315](https://github.com/M-Yamashita01/cronv-rb/commit/8cee315a1c6050dd0f59ed73fca10258a9fd8e77))
* add Renovate configuration for automated dependency updates ([e06a919](https://github.com/M-Yamashita01/cronv-rb/commit/e06a91941f34df27b445ad0d2313f44546da522b))
* add Renovate configuration for automated dependency updates ([3787121](https://github.com/M-Yamashita01/cronv-rb/commit/3787121de34a42f13c5a584bdee5f92e9fe0ed38))
* change Option attributes to accessors ([e1cb857](https://github.com/M-Yamashita01/cronv-rb/commit/e1cb857e1ac03063db69eff3cf7590f99ce58f3b))
* change Option attributes to accessors ([83f7c3e](https://github.com/M-Yamashita01/cronv-rb/commit/83f7c3e9596a52afb4cc91c165135489852c54ca))
* implement CLI main logic ([d44d1e7](https://github.com/M-Yamashita01/cronv-rb/commit/d44d1e78a80a3ea4232a0f7ea4808c1ac6851b43))
* implement CLI main logic ([e66d2e7](https://github.com/M-Yamashita01/cronv-rb/commit/e66d2e71c358a927da96009e6d2b4728cf6081d5))
* implement Visualizer#dump ([5b36118](https://github.com/M-Yamashita01/cronv-rb/commit/5b361186c61ff8839035a556a8816ea8c8d9f318))
* implement Visualizer#dump ([0019648](https://github.com/M-Yamashita01/cronv-rb/commit/0019648cf5531627435d78659907c7cedb2a82c7))
* trigger comparison workflow on PRs and weekly schedule ([ab9cc7d](https://github.com/M-Yamashita01/cronv-rb/commit/ab9cc7d64f50ed2a42b7260d50bb4670f9e0fbc5))
* trigger comparison workflow on PRs and weekly schedule ([06d0a7e](https://github.com/M-Yamashita01/cronv-rb/commit/06d0a7ef2c87418232c32d38a71fc5e28a835535))


### Bug Fixes

* disable Metrics/AbcSize for main method ([c282448](https://github.com/M-Yamashita01/cronv-rb/commit/c2824484a5829edc7c8132d613ad90f82f7c7b46))
* gracefully skip invalid crontab lines in Visualizer#add ([7b993d1](https://github.com/M-Yamashita01/cronv-rb/commit/7b993d176723c27ff843737ee91f1bde1ab6b236))
* gracefully skip invalid crontab lines in Visualizer#add ([f9bcc79](https://github.com/M-Yamashita01/cronv-rb/commit/f9bcc79eaa8e059646cd47a3276453aeab927fb2)), closes [#31](https://github.com/M-Yamashita01/cronv-rb/issues/31)
* handle schedule aliases and nil fugit_cron in record iter ([87eed6d](https://github.com/M-Yamashita01/cronv-rb/commit/87eed6d0fa2e8851da3b5d1de9d3fcaf068780c4))
* handle schedule aliases and nil fugit_cron in record iter ([469c8d2](https://github.com/M-Yamashita01/cronv-rb/commit/469c8d2e84c5006a6ef51e1338a660ec645e42e6))
* handle tab-separated crontab entries ([8160fe9](https://github.com/M-Yamashita01/cronv-rb/commit/8160fe90f51ff5d609e77e3ab6b7b09dbb412be4))
* handle tab-separated crontab entries ([0e91448](https://github.com/M-Yamashita01/cronv-rb/commit/0e91448a1fbb8ba028275a010b2869ab9e3cc808)), closes [#29](https://github.com/M-Yamashita01/cronv-rb/issues/29)
* install OSS cronv from master branch instead of pinned tag ([641c724](https://github.com/M-Yamashita01/cronv-rb/commit/641c724247b5e701a6287deb798f4a75d4f75730))
* install OSS cronv from master branch instead of pinned tag ([fc7153f](https://github.com/M-Yamashita01/cronv-rb/commit/fc7153fd191aa3d2e4c3f9275a46e9738b6e7127))
* log warning to stderr when skipping invalid crontab lines ([3c2bb6d](https://github.com/M-Yamashita01/cronv-rb/commit/3c2bb6d5d74ee69b74facee01e977a4075511db7))
* pin OSS cronv to v0.4.4 instead of [@latest](https://github.com/latest) ([b5b4275](https://github.com/M-Yamashita01/cronv-rb/commit/b5b42754477952a1c311e2084138ad085a58ac43))
* pin OSS cronv to v0.4.4 instead of [@latest](https://github.com/latest) ([79c1384](https://github.com/M-Yamashita01/cronv-rb/commit/79c1384a38b6cfe919c272d1f7075eeeb83e7b08))
* resolve RuboCop offenses in running_every_minutes? ([3ef9a25](https://github.com/M-Yamashita01/cronv-rb/commit/3ef9a25c12c17bf167e8a87b4892fd5ec92e7b6c))
* running_every_minutes? now checks all cron fields ([b49c9dc](https://github.com/M-Yamashita01/cronv-rb/commit/b49c9dc406791f10d4bd6c516ea1763c3c009095))
* running_every_minutes? now checks all cron fields ([2b836de](https://github.com/M-Yamashita01/cronv-rb/commit/2b836de29285316ad4aeeb3224b8c96d09977727)), closes [#30](https://github.com/M-Yamashita01/cronv-rb/issues/30)
* use latest version of OSS cronv in comparison workflow ([cd22a76](https://github.com/M-Yamashita01/cronv-rb/commit/cd22a76caa1616c93db5c43737cb5b626c33915f))
* use latest version of OSS cronv in comparison workflow ([20d2e2b](https://github.com/M-Yamashita01/cronv-rb/commit/20d2e2b9a217a311c0116b33d5ba80aff32e854c))
