// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/models/common/name_url.dart';

class Constants {
  static const BASE_API_URL = "https://watchlistfy-01e517696b58.herokuapp.com/api/v1";
  static const BASE_TMDB_URL = "https://www.themoviedb.org/";
  static const BASE_IMDB_URL = "https://www.imdb.com/title/";
  static const BASE_DOMAIN_URL = "https://watchlistfy.com";
  static const PRIVACY_POLICY_URL = "$BASE_DOMAIN_URL/privacy-policy.html";
  static const TERMS_CONDITIONS_URL = "$BASE_DOMAIN_URL/terms-conditions.html";

  static const THEME_PREF = "theme";
  static const INTRODUCTION_PREF = "is_introduction_presented";
  static const TOKEN_PREF = "refresh_token";

  static final ContentTags = ["popular", "upcoming", "top", "extra"];

  static final UserListStatus = [
    BackendRequestMapper("Active", "active"),
    BackendRequestMapper("Finished", "finished"),
    BackendRequestMapper("Dropped", "dropped"),
  ];

  //Status Requests
  static final MovieStatusRequests = [
    BackendRequestMapper("In Production", "production"),
    BackendRequestMapper("Released", "released"),
    BackendRequestMapper("Planned", "planned")
  ];

  static final TVSeriesStatusRequests = [
    BackendRequestMapper("In Production", "production"),
    BackendRequestMapper("Ended", "ended"),
    BackendRequestMapper("Airing", "airing")
  ];

  static final AnimeStatusRequests = [
    BackendRequestMapper("Airing", "airing"),
    BackendRequestMapper("Upcoming", "upcoming"),
    BackendRequestMapper("Finished", "finished")
  ];

  static final GamePlatformRequests = [
    BackendRequestMapper("PC", "PC"),
    BackendRequestMapper("PlayStation 5", "PlayStation 5"),
    BackendRequestMapper("PlayStation 4", "PlayStation 4"),
    BackendRequestMapper("Xbox Series S/X", "Xbox Series S/X"),
    BackendRequestMapper("Xbox One", "Xbox One"),
    BackendRequestMapper("Nintendo Switch", "Nintendo Switch"),
    BackendRequestMapper("Nintendo 3DS", "Nintendo 3DS"),
    BackendRequestMapper("Linux", "Linux"),
  ];

  //Sort Requests
  static final SortUpcomingRequests = BackendRequestMapper("Popularity", "popularity");

  static final SortRequests = [
    BackendRequestMapper("Popularity", "popularity"),
    BackendRequestMapper("Top Rated", "top"),
    BackendRequestMapper("Newest", "new"),
    BackendRequestMapper("Oldest", "old")
  ];

  static final SortRequestsStreamingPlatform = [
    BackendRequestMapper("Popularity", "popularity"),
    BackendRequestMapper("Newest", "new"),
    BackendRequestMapper("Oldest", "old")
  ];

  static final SortReviewRequests = [
    BackendRequestMapper("Popularity", "popularity"),
    BackendRequestMapper("Latest", "latest"),
    BackendRequestMapper("Oldest", "oldest")
  ];

  static final SortGameRequests = [
    BackendRequestMapper("Popularity", "popularity"),
    BackendRequestMapper("Metacritic", "top"),
    BackendRequestMapper("Newest", "new"),
    BackendRequestMapper("Oldest", "old")
  ];

  static final SortConsumeLaterRequests = [
    BackendRequestMapper("Newest", "new"),
    BackendRequestMapper("Oldest", "old"),
    BackendRequestMapper("Alphabetical", "alphabetical"),
    BackendRequestMapper("Reverse Alphabetical", "unalphabetical"),
  ];

  static final SortCustomListRequests = [
    // BackendRequestMapper("Popularity", "popularity"),
    BackendRequestMapper("Latest", "latest"),
    BackendRequestMapper("Oldest", "oldest"),
    BackendRequestMapper("Alphabetical", "alphabetical"),
    BackendRequestMapper("Reverse Alphabetical", "unalphabetical"),
  ];

  static final SortUserListRequests = [
    BackendRequestMapper("Score", "score"),
    BackendRequestMapper("Times Watched", "timeswatched"),
  ];

  static final UserListUIModes = ["Expanded", "Compact",];

  static final ContentUIModes = ["Grid", "List",];

  static final ConsumeLaterUIModes = ["Grid", "List",];

  //Genre List
  static final MovieGenreList = [
    NameUrl("Discover", "https://image.tmdb.org/t/p/w154/vv5a8u6e40kyH0Hp6HuamAgzRai.jpg"),
    NameUrl("Action", "https://www.themoviedb.org/t/p/w154/sQ5NKzWIusrpkv6Vq1V6GT0LHCh.jpg"),
    NameUrl("Adventure", "https://www.themoviedb.org/t/p/w154/r3pJ884C2cJ6F64X5Yd5sARuNZ6.jpg"),
    NameUrl("Animation", "https://www.themoviedb.org/t/p/w154/lWqjXgut48IK5f5IRbDBAoO2Epp.jpg"),
    NameUrl("Comedy", "https://www.themoviedb.org/t/p/w154/en971MEXui9diirXlogOrPKmsEn.jpg"),
    NameUrl("Crime", "https://www.themoviedb.org/t/p/w154/dWoKkgTis8pweSv7wihq03wPTKr.jpg"),
    NameUrl("Documentary", "https://www.themoviedb.org/t/p/w154/shtz6RdhhuXy8WXJENg1fWMG2dj.jpg"),
    NameUrl("Drama", "https://www.themoviedb.org/t/p/w154/hO7KbdvGOtDdeg0W4Y5nKEHeDDh.jpg"),
    NameUrl("Family", "https://www.themoviedb.org/t/p/w154/phhbtV5BEdn4TYLTMKFwYz2VSNl.jpg"),
    NameUrl("Fantasy", "https://www.themoviedb.org/t/p/w154/2u7zbn8EudG6kLlBzUYqP8RyFU4.jpg"),
    NameUrl("History", "https://www.themoviedb.org/t/p/w154/bdD39MpSVhKjxarTxLSfX6baoMP.jpg"),
    NameUrl("Horror", "https://www.themoviedb.org/t/p/w154/mmd1HnuvAzFc4iuVJcnBrhDNEKr.jpg"),
    NameUrl("Mystery", "https://www.themoviedb.org/t/p/w154/ntxArhtReGCqQSWFXk0c0Yt8uDO.jpg"),
    NameUrl("Romance", "https://www.themoviedb.org/t/p/w154/8LVhNcU8TT7DfIu2d13muZ8AWEO.jpg"),
    NameUrl("Science Fiction", "https://www.themoviedb.org/t/p/w154/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg"),
    NameUrl("Thriller", "https://www.themoviedb.org/t/p/w154/hiKmpZMGZsrkA3cdce8a7Dpos1j.jpg"),
    NameUrl("War", "https://www.themoviedb.org/t/p/w154/43qoaxPabvW2cDDI60Dam6mHV0K.jpg"),
    NameUrl("Western", "https://www.themoviedb.org/t/p/w154/eoCSp75lxatmIa6aGqfnzwtbttd.jpg"),
  ];

  static final TVGenreList = [
    NameUrl("Discover", "https://www.themoviedb.org/t/p/w154/q8eejQcg1bAqImEV8jh8RtBD4uH.jpg"),
    NameUrl("Action & Adventure", "https://www.themoviedb.org/t/p/w154/bKETHQDD3QoIRTMOP4dfKwisL3g.jpg"),
    NameUrl("Animation", "https://www.themoviedb.org/t/p/w154/8aCek7W6BovH7M4enWjqrGptvQ8.jpg"),
    NameUrl("Comedy", "https://www.themoviedb.org/t/p/w154/bY2J2Jq8rSrKm5xCFtzYzqFh44o.jpg"),
    NameUrl("Crime", "https://www.themoviedb.org/t/p/w154/7w165QdHmJuTHSQwEyJDBDpuDT7.jpg"),
    NameUrl("Documentary", "https://www.themoviedb.org/t/p/w154/2Nwbv0hrN8sThLvgooShcPqmFrO.jpg"),
    NameUrl("Drama", "https://www.themoviedb.org/t/p/w154/5NrSIzfcBOFI9HRGV4nRYgMGhDU.jpg"),
    NameUrl("Family", "https://www.themoviedb.org/t/p/w154/70YdbMELM4b8x8VXjlubymb2bQ0.jpg"),
    NameUrl("Kids", "https://www.themoviedb.org/t/p/w154/lhg7eA6CTOCL10QNVdKiyxkgPsL.jpg"),
    NameUrl("Mystery", "https://www.themoviedb.org/t/p/w154/56v2KjBlU4XaOv9rVYEQypROD7P.jpg"),
    NameUrl("Reality", "https://www.themoviedb.org/t/p/w154/mjdftSIZyG6kUItWiDKnzT9rO7F.jpg"),
    NameUrl("Sci-Fi & Fantasy", "https://www.themoviedb.org/t/p/w154/T7dvc9hEftOB5wUvJPQfcmvzVf.jpg"),
    NameUrl("War & Politics", "https://www.themoviedb.org/t/p/w154/3hPKf2eriMi6B2L5brfQH0A7MNe.jpg"),
    NameUrl("Western", "https://www.themoviedb.org/t/p/w154/At6G2kZRcTFwT28OmqYBsOpSj2p.jpg"),
  ];

  static final AnimeGenreList = [
    NameUrl("Discover", "https://www.themoviedb.org/t/p/w154/mRwV4W2BAEpte7xlawJP4fsBpmS.jpg"),
    NameUrl("Action", "https://www.themoviedb.org/t/p/w154/xVXbesCdNt37b3Kh6d3FgOtdajB.jpg"),
    NameUrl("Adventure", "https://www.themoviedb.org/t/p/w154/mBxsapX4DNhH1XkOlLp15He5sxL.jpg"),
    NameUrl("Avant Garde", "https://www.themoviedb.org/t/p/w154/fGXhmKyqRmx6NN3gQHeWNmiEryl.jpg"),
    NameUrl("Award Winning", "https://www.themoviedb.org/t/p/w154/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg"),
    NameUrl("Comedy", "https://www.themoviedb.org/t/p/w154/s0w8JbuNNxL1YgaHeDWih12C3jG.jpg"),
    NameUrl("Drama", "https://www.themoviedb.org/t/p/w154/mMtUybQ6hL24FXo0F3Z4j2KG7kZ.jpg"),
    NameUrl("Fantasy", "https://www.themoviedb.org/t/p/w154/dTFnU3EQB79aDM4HnUj06Y9Xbq1.jpg"),
    NameUrl("Horror", "https://www.themoviedb.org/t/p/w154/yOarY3Yo0NMkuTuft87M5oAZa3C.jpg"),
    NameUrl("Mystery", "https://www.themoviedb.org/t/p/w154/rRGnjRCHdDl3m3oCVSvo5z2E5c5.jpg"),
    NameUrl("Romance", "https://www.themoviedb.org/t/p/w154/dRGtv7BLMe00RAxtLkaWjcbzsTA.jpg"),
    NameUrl("Sci-Fi", "https://www.themoviedb.org/t/p/w154/36Ech63X2KU8JUXIBAo167kIC2k.jpg"),
    NameUrl("Slice of Life", "https://www.themoviedb.org/t/p/w154/4xvQGRIJpPEDf7HQdF0JkBVsmoX.jpg"),
    NameUrl("Sports", "https://www.themoviedb.org/t/p/w154/12mYMPE7Jy7rhDv0rn95GEtF94V.jpg"),
    NameUrl("Supernatural", "https://www.themoviedb.org/t/p/w154/kP5duNJEbTfXpBs6CITsaZ88pQi.jpg"),
    NameUrl("Suspense", "https://www.themoviedb.org/t/p/w154/uAjMQlbPkVHmUahhCouANlHSDW2.jpg"),
  ];

  static final GameGenreList = [
    NameUrl("Discover", "https://media.rawg.io/media/games/ba8/ba82c971336adfd290e4c0eab6504fcf.jpg"),
    NameUrl("Action", "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"),
    NameUrl("Adventure", "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg"),
    NameUrl("Arcade", "https://media.rawg.io/media/games/b4e/b4e4c73d5aa4ec66bbf75375c4847a2b.jpg"),
    NameUrl("Board Games", "https://media.rawg.io/media/games/742/7424c1f7d0a8da9ae29cd866f985698b.jpg"),
    NameUrl("Card", "https://media.rawg.io/media/games/1db/1dbc3d0c9de2709e21326cdcb91468ae.jpg"),
    NameUrl("Casual", "https://media.rawg.io/media/games/e74/e74458058b35e01c1ae3feeb39a3f724.jpg"),
    NameUrl("Family", "https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg"),
    NameUrl("Fighting", "https://media.rawg.io/media/games/aa3/aa36ba4b486a03ddfaef274fb4f5afd4.jpg"),
    NameUrl("Indie", "https://media.rawg.io/media/games/1f4/1f47a270b8f241e4676b14d39ec620f7.jpg"),
    NameUrl("Massively Multiplayer", "https://media.rawg.io/media/games/34b/34b1f1850a1c06fd971bc6ab3ac0ce0e.jpg"),
    NameUrl("Puzzle", "https://media.rawg.io/media/games/328/3283617cb7d75d67257fc58339188742.jpg"),
    NameUrl("Platformer", "https://media.rawg.io/media/games/942/9424d6bb763dc38d9378b488603c87fa.jpg"),
    NameUrl("Racing", "https://media.rawg.io/media/games/082/082365507ff04d456c700157072d35db.jpg"),
    NameUrl("RPG", "https://media.rawg.io/media/games/7cf/7cfc9220b401b7a300e409e539c9afd5.jpg"),
    NameUrl("Shooter", "https://media.rawg.io/media/games/998/9980c4296f311d8bcc5b451ca51e4fe1.jpg"),
    NameUrl("Simulation", "https://media.rawg.io/media/games/25c/25c4776ab5723d5d735d8bf617ca12d9.jpg"),
    NameUrl("Sports", "https://media.rawg.io/media/games/dbc/dbcb05bcdf104264db35de68d1e73909.jpg"),
    NameUrl("Strategy", "https://media.rawg.io/media/games/997/997ab4d67e96fb20a4092383477d4463.jpg"),
  ];

  static final MangaGenreList = [
    NameUrl("Discover", "https://cdn.myanimelist.net/images/manga/2/37846l.jpg"),
    NameUrl("Action", "https://cdn.myanimelist.net/images/manga/3/216464l.jpg"),
    NameUrl("Adventure", "https://www.themoviedb.org/t/p/w154/mBxsapX4DNhH1XkOlLp15He5sxL.jpg"),
    NameUrl("Avant Garde", "https://www.themoviedb.org/t/p/w154/fGXhmKyqRmx6NN3gQHeWNmiEryl.jpg"),
    NameUrl("Award Winning", "https://www.themoviedb.org/t/p/w154/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg"),
    NameUrl("Comedy", "https://www.themoviedb.org/t/p/w154/s0w8JbuNNxL1YgaHeDWih12C3jG.jpg"),
    NameUrl("Drama", "https://www.themoviedb.org/t/p/w154/mMtUybQ6hL24FXo0F3Z4j2KG7kZ.jpg"),
    NameUrl("Fantasy", "https://www.themoviedb.org/t/p/w154/dTFnU3EQB79aDM4HnUj06Y9Xbq1.jpg"),
    NameUrl("Horror", "https://www.themoviedb.org/t/p/w154/yOarY3Yo0NMkuTuft87M5oAZa3C.jpg"),
    NameUrl("Mystery", "https://www.themoviedb.org/t/p/w154/rRGnjRCHdDl3m3oCVSvo5z2E5c5.jpg"),
    NameUrl("Romance", "https://www.themoviedb.org/t/p/w154/dRGtv7BLMe00RAxtLkaWjcbzsTA.jpg"),
    NameUrl("Sci-Fi", "https://www.themoviedb.org/t/p/w154/36Ech63X2KU8JUXIBAo167kIC2k.jpg"),
    NameUrl("Slice of Life", "https://www.themoviedb.org/t/p/w154/4xvQGRIJpPEDf7HQdF0JkBVsmoX.jpg"),
    NameUrl("Sports", "https://www.themoviedb.org/t/p/w154/12mYMPE7Jy7rhDv0rn95GEtF94V.jpg"),
    NameUrl("Supernatural", "https://www.themoviedb.org/t/p/w154/kP5duNJEbTfXpBs6CITsaZ88pQi.jpg"),
    NameUrl("Suspense", "https://www.themoviedb.org/t/p/w154/uAjMQlbPkVHmUahhCouANlHSDW2.jpg"),
  ];

  static final AnimeThemeList = [
    BackendRequestMapper("Detective", "Detective"),
    BackendRequestMapper("Gore", "Gore"),
    BackendRequestMapper("Historical", "Historical"),
    BackendRequestMapper("Isekai", "Isekai"),
    BackendRequestMapper("Iyashikei", "Iyashikei"),
    BackendRequestMapper("Martial Arts", "Martial Arts"),
    BackendRequestMapper("Mecha", "Mecha"),
    BackendRequestMapper("Military", "Military"),
    BackendRequestMapper("Music", "Music"),
    BackendRequestMapper("Mythology", "Mythology"),
    BackendRequestMapper("Parody", "Parody"),
    BackendRequestMapper("Psychological", "Psychological"),
    BackendRequestMapper("Racing", "Racing"),
    BackendRequestMapper("Samurai", "Samurai"),
    BackendRequestMapper("School", "School"),
    BackendRequestMapper("Space", "Space"),
    BackendRequestMapper("Super Power", "Super Power"),
    BackendRequestMapper("Team Sports", "Team Sports"),
    BackendRequestMapper("Vampire", "Vampire"),
    BackendRequestMapper("Video Game", "Video Game"),
  ];

  static final AnimeDemographicsList = [
    BackendRequestMapper("Seinen", "Seinen"),
    BackendRequestMapper("Shoujo", "Shoujo"),
    BackendRequestMapper("Shounen", "Shounen"),
  ];

  static final AnimeSeasonList = [
    BackendRequestMapper("Winter", "winter"),
    BackendRequestMapper("Summer", "summer"),
    BackendRequestMapper("Fall", "fall"),
    BackendRequestMapper("Spring", "spring"),
  ];

  static final MangaThemeList = [
    BackendRequestMapper("Anthropomorphic", "Anthropomorphic"),
    BackendRequestMapper("CGDCT", "CGDCT"),
    BackendRequestMapper("Combat Sports", "Combat Sports"),
    BackendRequestMapper("Delinquents", "Delinquents"),
    BackendRequestMapper("Detective", "Detective"),
    BackendRequestMapper("Gore", "Gore"),
    BackendRequestMapper("High Stakes Game", "High Stakes Game"),
    BackendRequestMapper("Historical", "Historical"),
    BackendRequestMapper("Isekai", "Isekai"),
    BackendRequestMapper("Iyashikei", "Iyashikei"),
    BackendRequestMapper("Martial Arts", "Martial Arts"),
    BackendRequestMapper("Mecha", "Mecha"),
    BackendRequestMapper("Medical", "Medical"),
    BackendRequestMapper("Military", "Military"),
    BackendRequestMapper("Music", "Music"),
    BackendRequestMapper("Mythology", "Mythology"),
    BackendRequestMapper("Parody", "Parody"),
    BackendRequestMapper("Psychological", "Psychological"),
    BackendRequestMapper("Racing", "Racing"),
    BackendRequestMapper("Reincarnation", "Reincarnation"),
    BackendRequestMapper("Samurai", "Samurai"),
    BackendRequestMapper("School", "School"),
    BackendRequestMapper("Space", "Space"),
    BackendRequestMapper("Strategy Game", "Strategy Game"),
    BackendRequestMapper("Super Power", "Super Power"),
    BackendRequestMapper("Survival", "Survival"),
    BackendRequestMapper("Team Sports", "Team Sports"),
    BackendRequestMapper("Time Travel", "Time Travel"),
    BackendRequestMapper("Vampire", "Vampire"),
    BackendRequestMapper("Video Game", "Video Game"),
    BackendRequestMapper("Workplace", "Workplace"),
  ];

  static final MangaDemographicsList = [
    BackendRequestMapper("Josei", "Josei"),
    BackendRequestMapper("Seinen", "Seinen"),
    BackendRequestMapper("Shoujo", "Shoujo"),
    BackendRequestMapper("Shounen", "Shounen"),
  ];

  static final DecadeList = [
    BackendRequestMapper("1980s", "1980"),
    BackendRequestMapper("1990s", "1990"),
    BackendRequestMapper("2000s", "2000"),
    BackendRequestMapper("2010s", "2010"),
    BackendRequestMapper("2020s", "2020"),
  ];

  static final NumOfSeasonList = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"
  ];

  static final ProfileImageList = [
    //Movies
    "https://image.tmdb.org/t/p/w300/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg",
    "https://www.themoviedb.org/t/p/w300/adlPZoRdysBMVTSTsGamcn5apYt.jpg",
    "https://www.themoviedb.org/t/p/w300/pm0RiwNpSja8gR0BTWpxo5a9Bbl.jpg",
    "https://www.themoviedb.org/t/p/w300/bYeg8ssTvpFFFpWYbAkhrCCgedX.jpg",
    "https://www.themoviedb.org/t/p/w300/rr7E0NoGKxvbkb89eR1GwfoYjpA.jpg",
    "https://www.themoviedb.org/t/p/w300/cbcpDn6XJaIGoOil1bKuskU8ds4.jpg",
    "https://www.themoviedb.org/t/p/w300/t7aX68mIQhML2xVw9y5vsMTsz5N.jpg",
    "https://www.themoviedb.org/t/p/w300/ff2ti5DkA9UYLzyqhQfI2kZqEuh.jpg",
    "https://www.themoviedb.org/t/p/w300/hWqju5EapuE8d9N0Cg7lsrruVH6.jpg",
    "https://www.themoviedb.org/t/p/w300/sa4iZ5QpvWmuGT2sDjfgfqy7ArE.jpg",
    "https://www.themoviedb.org/t/p/w300/ByDf0zjLSumz1MP1cDEo2JWVtU.jpg",
    "https://www.themoviedb.org/t/p/w300/by5QHLRVowUr7C2HJb3T99B8djj.jpg",
    "https://www.themoviedb.org/t/p/w300/91tAohcYYbs8CADYWC5NkAqUp4w.jpg",
    //TVSeries
    "https://www.themoviedb.org/t/p/w300/63FA8vwSZnXkGxedrDQwni4JuZN.jpg",
    "https://www.themoviedb.org/t/p/w300/q8eejQcg1bAqImEV8jh8RtBD4uH.jpg",
    "https://www.themoviedb.org/t/p/w300/9zcbqSxdsRMZWHYtyCd1nXPr2xq.jpg",
    "https://www.themoviedb.org/t/p/w300/4oE4vT4q0AD2cX3wcMBVzCsME8G.jpg",
    "https://www.themoviedb.org/t/p/w300/r40ke0kVPhL5b1oHgQaB5BatoSk.jpg",
    "https://www.themoviedb.org/t/p/w300/7w165QdHmJuTHSQwEyJDBDpuDT7.jpg",
    "https://www.themoviedb.org/t/p/w300/5jLHclxjoxvwg5uALMn2IO5HyDz.jpg",
    "https://www.themoviedb.org/t/p/w300/AgyXlYwp2I0uw7GoImt1c0kqWYv.jpg",
    "https://www.themoviedb.org/t/p/w300/uEYKe7kt3ngFFK2guXLRf2F3yLB.jpg",
    "https://www.themoviedb.org/t/p/w300/qx8XQund44cecIJiX2Yb4SUeiT.jpg",
    "https://www.themoviedb.org/t/p/w300/f2sLP1SKXdfy9tICjCpm6bVMDX2.jpg",
    "https://www.themoviedb.org/t/p/w300/2fC21HahBFcldyVCGInf0TvOhtX.jpg",
    //Anime
    "https://www.themoviedb.org/t/p/w300/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg",
    "https://www.themoviedb.org/t/p/w300/5DUMPBSnHOZsbBv81GFXZXvDpo6.jpg",
    "https://www.themoviedb.org/t/p/w300/ie6goEzn1xXu6bqghA5EKWRksJH.jpg",
    "https://www.themoviedb.org/t/p/w300/2yuHsYz1rDU1uiaIsmhn8WknaYK.jpg",
    "https://www.themoviedb.org/t/p/w300/ygjjhKcImW9C67tYSFVjtGkOiIp.jpg",
    "https://www.themoviedb.org/t/p/w300/bFKKyCI89Xq98Gul8cGox8K3sZa.jpg",
    "https://www.themoviedb.org/t/p/w300/rdV1Cn61RIacdWMX9BnioP1LPj6.jpg",
    "https://www.themoviedb.org/t/p/w300/dTFnU3EQB79aDM4HnUj06Y9Xbq1.jpg",
    "https://www.themoviedb.org/t/p/w300/pj0VFMLbzCCMVhxKiKaKnowU7Iz.jpg",
    "https://www.themoviedb.org/t/p/w300/3IqZkiolIli6yEfq3JYsnm3se00.jpg",
    "https://www.themoviedb.org/t/p/w300/brO0acsI82ikvp7S0yszhbUupiF.jpg",
    //Game
    "https://upload.wikimedia.org/wikipedia/tr/f/fc/Rivyal%C4%B1_Geralt.png?20170305192601",
    "https://media.rawg.io/media/games/4be/4be6a6ad0364751a96229c56bf69be59.jpg",
    "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
    "https://media.rawg.io/media/games/fc1/fc1307a2774506b5bd65d7e8424664a7.jpg",
    "https://media.rawg.io/media/games/b8c/b8c243eaa0fbac8115e0cdccac3f91dc.jpg",
    "https://media.rawg.io/media/games/7cf/7cfc9220b401b7a300e409e539c9afd5.jpg",
    "https://media.rawg.io/media/games/ba8/ba82c971336adfd290e4c0eab6504fcf.jpg",
  ];
}