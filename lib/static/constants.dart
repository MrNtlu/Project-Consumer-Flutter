// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static const WHATSNEW_PREF = "whats_new";
  static const FEEDBACK_PREF = "feedback";
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

  static final GamePlatformIcons = [
    FontAwesomeIcons.computerMouse,
    FontAwesomeIcons.playstation,
    FontAwesomeIcons.playstation,
    FontAwesomeIcons.xbox,
    FontAwesomeIcons.xbox,
    Icons.gamepad_outlined,
    Icons.gamepad_outlined,
    FontAwesomeIcons.linux,
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
    BackendRequestMapper("Recently Added", "new"),
    BackendRequestMapper("Previously Added", "old"),
    BackendRequestMapper("Release Date", "soon"),
    BackendRequestMapper("Reverse Release Date", "later"),
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
    BackendRequestMapper("Alphabetical", "alphabetical"),
    BackendRequestMapper("Reverse Alphabetical", "unalphabetical"),
  ];

  static final UserListUIModes = ["Expanded", "Compact", "Grid View"];

  static final ProfileStatisticsUIModes = ["Expanded", "Collapsed",];

  static final ContentUIModes = ["Grid", "List",];

  static final ConsumeLaterUIModes = ["Grid", "List",];

  static final ProfileStatsInterval = [
    BackendRequestMapper("Weekly", "weekly"),
    BackendRequestMapper("Monthly", "monthly"),
    BackendRequestMapper("3 Months", "3months"),
  ];

  //Streaming Platform List
  static final MovieStreamingPlatformList = [
    // Most Populars
    BackendRequestMapperWithImage("Netflix", "Netflix", image: "https://image.tmdb.org/t/p/w154/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"),
    BackendRequestMapperWithImage("Amazon Prime Video", "Amazon Prime Video", image: "https://image.tmdb.org/t/p/w154/dQeAar5H991VYporEjUspolDarG.jpg"),
    BackendRequestMapperWithImage("Disney Plus", "Disney Plus", image: "https://image.tmdb.org/t/p/w154/7YPdUs60C9qQQQfOFCgxpnF07D9.jpg"),
    BackendRequestMapperWithImage("HBO Max", "HBO Max", image: "https://image.tmdb.org/t/p/w154/b8edpTaLCHFrUnhpGQIZJUpFX7T.jpg"),
    BackendRequestMapperWithImage("Hulu", "Hulu", image: "https://image.tmdb.org/t/p/w154/bxBlRPEPpMVDc4jMhSrTf2339DW.jpg"),
    BackendRequestMapperWithImage("Apple TV Plus", "Apple TV Plus", image: "https://image.tmdb.org/t/p/original/2E03IAZsX4ZaUqM7tXlctEPMGWS.jpg"),
    BackendRequestMapperWithImage("Paramount Plus", "Paramount Plus", image: "https://image.tmdb.org/t/p/w154/h5DcR0J2EESLitnhR8xLG1QymTE.jpg"),
    // From other countries
    BackendRequestMapperWithImage("Rakuten Viki", "Rakuten Viki", image: "https://image.tmdb.org/t/p/w154/5L2bwr9DhUg28oSMEPRCNwB2y7B.jpg"),
    BackendRequestMapperWithImage("FilmBox+", "FilmBox+", image: "https://image.tmdb.org/t/p/w154/fbveJTcro9Xw2KuPIIoPPePHiwy.jpg"),
    BackendRequestMapperWithImage("MUBI", "MUBI", image: "https://image.tmdb.org/t/p/original/fj9Y8iIMFUC6952HwxbGixTQPb7.jpg"),
    BackendRequestMapperWithImage("Sky Go", "Sky Go", image: "https://image.tmdb.org/t/p/w154/1UrT2H9x6DuQ9ytNhsSCUFtTUwS.jpg"),
    BackendRequestMapperWithImage("Shahid VIP", "Shahid VIP", image: "https://image.tmdb.org/t/p/w154/7qZED0kLBtiV8mLRNBtW4PQCAqW.jpg"),
    BackendRequestMapperWithImage("Hoopla", "Hoopla", image: "https://image.tmdb.org/t/p/w154/j7D006Uy3UWwZ6G0xH6BMgIWTzH.jpg"),
    BackendRequestMapperWithImage("KPN", "KPN", image: "https://image.tmdb.org/t/p/w154/nzjqsR28PVVp5GJAlHtbBArNKqN.jpg"),
    BackendRequestMapperWithImage("TV+", "TV+", image: "https://image.tmdb.org/t/p/w154/c8ryDZroFQtuyRVPBwXq5PLpTWV.jpg"),
    BackendRequestMapperWithImage("TOD", "TOD", image: "https://image.tmdb.org/t/p/original//eXxCDzaz4F7bkkgkZ8p6AbNQ8Dk.jpg"),
    BackendRequestMapperWithImage("blutv", "blutv", image: "https://image.tmdb.org/t/p/w154/dqRpKX6vcos334v9huMpNPKHlD8.jpg"),
    BackendRequestMapperWithImage("Canal+", "Canal+", image: "https://image.tmdb.org/t/p/w154/eBXzkFEupZjKaIKY7zBUaSdCY8I.jpg"),
    BackendRequestMapperWithImage("Classix", "Classix", image: "https://image.tmdb.org/t/p/w154/uFjAjvrKMII0H766QzyHDNkZdKX.jpg"),
    BackendRequestMapperWithImage("Cultpix", "Cultpix", image: "https://image.tmdb.org/t/p/w154/uauVx3dGWt0GICqdMCBYJObd3Mo.jpg"),
    BackendRequestMapperWithImage("SkyShowtime", "SkyShowtime", image: "https://image.tmdb.org/t/p/w154/gQbqEYd0C9uprYxEUqTM589qn8g.jpg"),
    BackendRequestMapperWithImage("AMC+", "AMC+", image: "https://image.tmdb.org/t/p/w154/ovmu6uot1XVvsemM2dDySXLiX57.jpg"),
  ];

  static final TVStreamingPlatformList = [
    // Most Populars
    BackendRequestMapperWithImage("Netflix", "Netflix", image: "https://image.tmdb.org/t/p/w154/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"),
    BackendRequestMapperWithImage("Amazon Prime Video", "Amazon Prime Video", image: "https://image.tmdb.org/t/p/w154/dQeAar5H991VYporEjUspolDarG.jpg"),
    BackendRequestMapperWithImage("Disney Plus", "Disney Plus", image: "https://image.tmdb.org/t/p/w154/7YPdUs60C9qQQQfOFCgxpnF07D9.jpg"),
    BackendRequestMapperWithImage("HBO Max", "HBO Max", image: "https://image.tmdb.org/t/p/w154/b8edpTaLCHFrUnhpGQIZJUpFX7T.jpg"),
    BackendRequestMapperWithImage("Hulu", "Hulu", image: "https://image.tmdb.org/t/p/w154/bxBlRPEPpMVDc4jMhSrTf2339DW.jpg"),
    BackendRequestMapperWithImage("Apple TV Plus", "Apple TV Plus", image: "https://image.tmdb.org/t/p/original/2E03IAZsX4ZaUqM7tXlctEPMGWS.jpg"),
    BackendRequestMapperWithImage("Paramount Plus", "Paramount Plus", image: "https://image.tmdb.org/t/p/w154/h5DcR0J2EESLitnhR8xLG1QymTE.jpg"),
    // From other countries
    BackendRequestMapperWithImage("Peacock Premium", "Peacock Premium", image: "https://image.tmdb.org/t/p/w154/drPlq5beqXtBaP7MNs8W616YRhm.jpg"),
    BackendRequestMapperWithImage("Rakuten Viki", "Rakuten Viki", image: "https://image.tmdb.org/t/p/w154/5L2bwr9DhUg28oSMEPRCNwB2y7B.jpg"),
    BackendRequestMapperWithImage("Discovery+", "Discovery+", image: "https://image.tmdb.org/t/p/w154/eMTnWwNVtThkjvQA6zwxaoJG9NE.jpg"),
    BackendRequestMapperWithImage("Sky Go", "Sky Go", image: "https://image.tmdb.org/t/p/w154/1UrT2H9x6DuQ9ytNhsSCUFtTUwS.jpg"),
    BackendRequestMapperWithImage("Shahid VIP", "Shahid VIP", image: "https://image.tmdb.org/t/p/w154/7qZED0kLBtiV8mLRNBtW4PQCAqW.jpg"),
    BackendRequestMapperWithImage("Canal+", "Canal+", image: "https://image.tmdb.org/t/p/w154/eBXzkFEupZjKaIKY7zBUaSdCY8I.jpg"),
    BackendRequestMapperWithImage("YouTube Premium", "YouTube Premium", image: "https://image.tmdb.org/t/p/w154/rMb93u1tBeErSYLv79zSTR07UdO.jpg"),
    BackendRequestMapperWithImage("Viaplay", "Viaplay", image: "https://image.tmdb.org/t/p/w154/bnoTnLzz2MAhK3Yc6P9KXe5drIz.jpg"),
    BackendRequestMapperWithImage("Kocowa", "Kocowa", image: "https://image.tmdb.org/t/p/w154/hwsU65QW7A4dbMEWkDpgHyCNcfS.jpg"),
    BackendRequestMapperWithImage("wavve", "wavve", image: "https://image.tmdb.org/t/p/w154/hPcjSaWfMwEqXaCMu7Fkb529Dkc.jpg"),
    BackendRequestMapperWithImage("fuboTV", "fuboTV", image: "https://image.tmdb.org/t/p/w154/rugttVJKzDAwVbM99gAV6i3g59Q.jpg"),
    BackendRequestMapperWithImage("TV+", "TV+", image: "https://image.tmdb.org/t/p/w154/c8ryDZroFQtuyRVPBwXq5PLpTWV.jpg"),
    BackendRequestMapperWithImage("TOD", "TOD", image: "https://image.tmdb.org/t/p/original//eXxCDzaz4F7bkkgkZ8p6AbNQ8Dk.jpg"),
    BackendRequestMapperWithImage("blutv", "blutv", image: "https://image.tmdb.org/t/p/w154/dqRpKX6vcos334v9huMpNPKHlD8.jpg"),
    BackendRequestMapperWithImage("BritBox", "BritBox", image: "https://image.tmdb.org/t/p/w154/1pDWY6EKtfclVbZTPVWc7WPwy8Q.jpg"),
    BackendRequestMapperWithImage("Hoopla", "Hoopla", image: "https://image.tmdb.org/t/p/w154/j7D006Uy3UWwZ6G0xH6BMgIWTzH.jpg"),
  ];

  static final AnimeStreamingPlatformList = [
    BackendRequestMapperWithImage("Crunchyroll", "Crunchyroll", image: "https://image.tmdb.org/t/p/w154/mXeC4TrcgdU6ltE9bCBCEORwSQR.jpg"),
    BackendRequestMapperWithImage("Netflix", "Netflix", image: "https://image.tmdb.org/t/p/w154/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"),
    BackendRequestMapperWithImage("Disney+", "Disney+", image: "https://image.tmdb.org/t/p/w154/7YPdUs60C9qQQQfOFCgxpnF07D9.jpg"),
    BackendRequestMapperWithImage("Aniplus TV", "Aniplus TV", image: "https://logo.clearbit.com/aniplus-asia.com"),
    BackendRequestMapperWithImage("HIDIVE", "HIDIVE", image: "https://logo.clearbit.com/hidive.com/"),
    BackendRequestMapperWithImage("Bilibili", "Bilibili", image: "https://logo.clearbit.com/bilibili.com"),
    BackendRequestMapperWithImage("Anime Digital Network", "Anime Digital Network", image: "https://logo.clearbit.com/animationdigitalnetwork.fr"),
    BackendRequestMapperWithImage("Shahid", "Shahid", image: "https://logo.clearbit.com/shahid.mbc.net"),
    BackendRequestMapperWithImage("Wakanim", "Wakanim", image: "https://www.wakanim.tv/assets/img/svg/logo.svg"),
  ];

  static final StreamingPlatformList = [
    // Watch Later
    // Most Popular Ones
    BackendRequestMapperWithImage("Netflix", "Netflix", image: "https://image.tmdb.org/t/p/w154/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"),
    BackendRequestMapperWithImage("Amazon Prime Video", "Amazon Prime Video", image: "https://image.tmdb.org/t/p/w154/dQeAar5H991VYporEjUspolDarG.jpg"),
    BackendRequestMapperWithImage("Disney Plus", "Disney Plus", image: "https://image.tmdb.org/t/p/w154/7YPdUs60C9qQQQfOFCgxpnF07D9.jpg"),
    BackendRequestMapperWithImage("Crunchyroll", "Crunchyroll", image: "https://image.tmdb.org/t/p/w154/mXeC4TrcgdU6ltE9bCBCEORwSQR.jpg"),
    BackendRequestMapperWithImage("HBO Max", "HBO Max", image: "https://image.tmdb.org/t/p/w154/b8edpTaLCHFrUnhpGQIZJUpFX7T.jpg"),
    BackendRequestMapperWithImage("Hulu", "Hulu", image: "https://image.tmdb.org/t/p/w154/bxBlRPEPpMVDc4jMhSrTf2339DW.jpg"),
    BackendRequestMapperWithImage("Apple TV Plus", "Apple TV Plus", image: "https://image.tmdb.org/t/p/original/2E03IAZsX4ZaUqM7tXlctEPMGWS.jpg"),
    BackendRequestMapperWithImage("Paramount Plus", "Paramount Plus", image: "https://image.tmdb.org/t/p/w154/h5DcR0J2EESLitnhR8xLG1QymTE.jpg"),
    BackendRequestMapperWithImage("Rakuten Viki", "Rakuten Viki", image: "https://image.tmdb.org/t/p/w154/5L2bwr9DhUg28oSMEPRCNwB2y7B.jpg"),
    BackendRequestMapperWithImage("Shahid VIP", "Shahid VIP", image: "https://image.tmdb.org/t/p/w154/7qZED0kLBtiV8mLRNBtW4PQCAqW.jpg"),
    BackendRequestMapperWithImage("Shahid", "Shahid", image: "https://logo.clearbit.com/shahid.mbc.net"),
    BackendRequestMapperWithImage("FilmBox+", "FilmBox+", image: "https://image.tmdb.org/t/p/w154/fbveJTcro9Xw2KuPIIoPPePHiwy.jpg"),
    BackendRequestMapperWithImage("Sky Go", "Sky Go", image: "https://image.tmdb.org/t/p/w154/1UrT2H9x6DuQ9ytNhsSCUFtTUwS.jpg"),
    BackendRequestMapperWithImage("Canal+", "Canal+", image: "https://image.tmdb.org/t/p/w154/eBXzkFEupZjKaIKY7zBUaSdCY8I.jpg"),
    BackendRequestMapperWithImage("TV+", "TV+", image: "https://image.tmdb.org/t/p/w154/c8ryDZroFQtuyRVPBwXq5PLpTWV.jpg"),
    BackendRequestMapperWithImage("TOD", "TOD", image: "https://image.tmdb.org/t/p/original//eXxCDzaz4F7bkkgkZ8p6AbNQ8Dk.jpg"),
    BackendRequestMapperWithImage("blutv", "blutv", image: "https://image.tmdb.org/t/p/w154/dqRpKX6vcos334v9huMpNPKHlD8.jpg"),
    BackendRequestMapperWithImage("Hoopla", "Hoopla", image: "https://image.tmdb.org/t/p/w154/j7D006Uy3UWwZ6G0xH6BMgIWTzH.jpg"),
  ];

  // Popular Studios List
  static final MoviePopularStudiosList = [ // 25 in total
    BackendRequestMapperWithImage("Warner Bros. Pictures", "Warner Bros. Pictures", image: "https://image.tmdb.org/t/p/w342/zhD3hhtKB5qyv7ZeL4uLpNxgMVU.png"),
    BackendRequestMapperWithImage("Universal Pictures", "Universal Pictures", image: "https://image.tmdb.org/t/p/w342/8lvHyhjr8oUKOOy2dKXoALWKdp0.png"),
    BackendRequestMapperWithImage("Marvel Studios", "Marvel Studios", image: "https://image.tmdb.org/t/p/w342/hUzeosd33nzE5MCNsZxCGEKTXaQ.png"),
    BackendRequestMapperWithImage("Paramount", "Paramount", image: "https://image.tmdb.org/t/p/w342/gz66EfNoYPqHTYI4q9UEN4CbHRc.png"),
    BackendRequestMapperWithImage("Columbia Pictures", "Columbia Pictures", image: "https://image.tmdb.org/t/p/w342/71BqEFAF4V3qjjMPCpLuyJFB9A.png"),
    BackendRequestMapperWithImage("20th Century Fox", "20th Century Fox", image: "https://image.tmdb.org/t/p/w342/qZCc1lty5FzX30aOCVRBLzaVmcp.png"),
    BackendRequestMapperWithImage("Metro-Goldwyn-Mayer", "Metro-Goldwyn-Mayer", image: "https://image.tmdb.org/t/p/w342/usUnaYV6hQnlVAXP6r4HwrlLFPG.png"),
    BackendRequestMapperWithImage("Canal+", "Canal+", image: "https://image.tmdb.org/t/p/w342/9aotxauvc9685tq9pTcRJszuT06.png"),
    BackendRequestMapperWithImage("Walt Disney Pictures", "Walt Disney Pictures", image: "https://image.tmdb.org/t/p/w342/wdrCwmRnLFJhEoH8GSfymY85KHT.png"),
    BackendRequestMapperWithImage("Lionsgate", "Lionsgate", image: "https://image.tmdb.org/t/p/w342/cisLn1YAUuptXVBa0xjq7ST9cH0.png"),
    BackendRequestMapperWithImage("Legendary Pictures", "Legendary Pictures", image: "https://image.tmdb.org/t/p/w342/8M99Dkt23MjQMTTWukq4m5XsEuo.png"),
    BackendRequestMapperWithImage("New Line Cinema", "New Line Cinema", image: "https://image.tmdb.org/t/p/w342/iaYpEp3LQmb8AfAtmTvpqd4149c.png"),
    BackendRequestMapperWithImage("Pixar", "Pixar", image: "https://image.tmdb.org/t/p/w342/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png"),
    BackendRequestMapperWithImage("DreamWorks Animation", "DreamWorks Animation", image: "https://image.tmdb.org/t/p/w342/kP7t6RwGz2AvvTkvnI1uteEwHet.png"),
    BackendRequestMapperWithImage("Warner Bros. Animation", "Warner Bros. Animation", image: "https://image.tmdb.org/t/p/w342/l5zW8jjmQOCx2dFmvnmbYmqoBmL.png"),
    BackendRequestMapperWithImage("TOHO", "TOHO", image: "https://image.tmdb.org/t/p/w342/iDw9Xxok1d9WAM2zFicI8p3khTH.png"),
    BackendRequestMapperWithImage("Ingenious Media", "Ingenious Media", image: "https://image.tmdb.org/t/p/w342/jrgCuaQsY9ouP5ILZf4Dq4ZOkIX.png"),
    BackendRequestMapperWithImage("United Artists", "United Artists", image: "https://image.tmdb.org/t/p/w342/1SEj4nyG3JPBSKBbFhtdcHRaIF9.png"),
    BackendRequestMapperWithImage("StudioCanal", "StudioCanal", image: "https://image.tmdb.org/t/p/w342/5LEHONGkZBIoWvp1ygHOF8iyi1M.png"),
    BackendRequestMapperWithImage("Miramax", "Miramax", image: "https://image.tmdb.org/t/p/w342/m6AHu84oZQxvq7n1rsvMNJIAsMu.png"),
    BackendRequestMapperWithImage("Touchstone Pictures", "Touchstone Pictures", image: "https://image.tmdb.org/t/p/w342/ou5BUbtulr6tIt699q6xJiEQTR9.png"),
    BackendRequestMapperWithImage("Film4 Productions", "Film4 Productions", image: "https://image.tmdb.org/t/p/w342/e8EXNSfwr5E9d3TR8dHKbQnQK4W.png"),
    BackendRequestMapperWithImage("TriStar Pictures", "TriStar Pictures", image: "https://image.tmdb.org/t/p/w342/eC0bWHVjnjUducyA6YFoEFqnPMC.png"),
    BackendRequestMapperWithImage("BBC Film", "BBC Film", image: "https://image.tmdb.org/t/p/w342/aW0IpM9d4Zjj978EqgDVSxXXhTj.png"),
    BackendRequestMapperWithImage("Village Roadshow Pictures", "Village Roadshow Pictures", image: "https://image.tmdb.org/t/p/w342/at4uYdwAAgNRKhZuuFX8ShKSybw.png"),
  ];

  static final TVPopularStudiosList = [ // 25 in total
    BackendRequestMapperWithImage("TVB", "TVB", image: "https://image.tmdb.org/t/p/w342/4OKzkasr0IV8CSqejjgRfKw7e0m.png"),
    BackendRequestMapperWithImage("Sony Pictures Television Studios", "Sony Pictures Television Studios", image: "https://image.tmdb.org/t/p/w342/aCbASRcI1MI7DXjPbSW9Fcv9uGR.png"),
    BackendRequestMapperWithImage("Warner Bros. Television", "Warner Bros. Television", image: "https://image.tmdb.org/t/p/w342/pJJw98MtNFC9cHn3o15G7vaUnnX.png"),
    BackendRequestMapperWithImage("20th Century Fox Television", "20th Century Fox Television", image: "https://image.tmdb.org/t/p/w342/31h94rG9hzjprXoYNy3L1ErUya2.png"),
    BackendRequestMapperWithImage("Paramount Television Studios", "Paramount Television Studios", image: "https://image.tmdb.org/t/p/w342/of4mmVt6egYaO9oERJbuUxMOTkj.png"),
    BackendRequestMapperWithImage("Disney Television Animation", "Disney Television Animation", image: "https://image.tmdb.org/t/p/w342/jTPNzDEn7eHmp3nEXEEtkHm6jLg.png"),
    BackendRequestMapperWithImage("TBS", "TBS", image: "https://image.tmdb.org/t/p/w342/lUACMATs6jcscXIrzNCQzbvNVN5.png"),
    BackendRequestMapperWithImage("Universal Television", "Universal Television", image: "https://image.tmdb.org/t/p/w342/jeTxdjXhzgKZyLr3l9MllkTn3fy.png"),
    BackendRequestMapperWithImage("CBS Studios", "CBS Studios", image: "https://image.tmdb.org/t/p/w342/19kn4jVvpc3sAL3YpZNb3elhSMl.png"),
    BackendRequestMapperWithImage("ABC Studios", "ABC Studios", image: "https://image.tmdb.org/t/p/w342/vOH8dyQhLK01pg5fYkgiS31jlFm.png"),
    BackendRequestMapperWithImage("BBC", "BBC", image: "https://image.tmdb.org/t/p/w342/dqT3yOTlfJRmtvk52Ccd1O6dZ0A.png"),
    BackendRequestMapperWithImage("HBO", "HBO", image: "https://image.tmdb.org/t/p/w342/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
    BackendRequestMapperWithImage("Cartoon Network Studios", "Cartoon Network Studios", image: "https://image.tmdb.org/t/p/w342/uYMD8NPD7Eph0cFd1WJZJrot1Fb.png"),
    BackendRequestMapperWithImage("Warner Bros. Animation", "Warner Bros. Animation", image: "https://image.tmdb.org/t/p/w342/l5zW8jjmQOCx2dFmvnmbYmqoBmL.png"),
    BackendRequestMapperWithImage("Nickelodeon Productions", "Nickelodeon Productions", image: "https://image.tmdb.org/t/p/w342/2GFJ3jJ7dhjqcOGj41aTwd3OhQT.png"),
    BackendRequestMapperWithImage("20th Television Animation", "20th Television Animation", image: "https://image.tmdb.org/t/p/w342/wLFPu95hIMmyLR5hdtvYaMuK0tG.png"),
    BackendRequestMapperWithImage("Amazon Studios", "Amazon Studios", image: "https://image.tmdb.org/t/p/w342/oRR9EXVoKP9szDkVKlze5HVJS7g.png"),
    BackendRequestMapperWithImage("Touchstone Television", "Touchstone Television", image: "https://image.tmdb.org/t/p/w342/wwaKUcOENHix2jxLfFBfNkCtOEQ.png"),
    BackendRequestMapperWithImage("FX Productions", "FX Productions", image: "https://image.tmdb.org/t/p/w342/5cT4zwHA66uNAr2p3CcBDLddXu2.png"),
    BackendRequestMapperWithImage("DC Entertainment", "DC Entertainment", image: "https://image.tmdb.org/t/p/w342/2Tc1P3Ac8M479naPp1kYT3izLS5.png"),
    BackendRequestMapperWithImage("NHK", "NHK", image: "https://image.tmdb.org/t/p/w342/3MuBcEqLa5QRkZTpXBLzyk9zOmO.png"),
    BackendRequestMapperWithImage("Marvel Television", "Marvel Television", image: "https://image.tmdb.org/t/p/w342/v2y3LuLxYtW36hvLa8IDGQk3Oql.png"),
    BackendRequestMapperWithImage("Studio Dragon", "Studio Dragon", image: "https://image.tmdb.org/t/p/w342/vzzqRwqTin3iAAMw2JlrmVPNnPa.png"),
    BackendRequestMapperWithImage("SLL", "SLL", image: "https://image.tmdb.org/t/p/w342/8FwCT7KohE031xFLBeRMZlbuzSr.png"),
    BackendRequestMapperWithImage("MBC", "MBC", image: "https://image.tmdb.org/t/p/w342/muK9W0KLV8KfEnR7MYu0YpfpdnO.png"),
  ];

  static final AnimePopularStudiosList = [ // 20 in total
    BackendRequestMapperWithImage("A-1 Pictures", "A-1 Pictures", image: "https://cdn.myanimelist.net/s/common/company_logos/4713c58b-833f-4c92-bf4a-0e2f7af8a461_600x600_i?s=925a453653da58d385adb82b5d423a69"),
    BackendRequestMapperWithImage("Madhouse", "Madhouse", image: "https://cdn.myanimelist.net/s/common/company_logos/e68488ab-f0a0-411f-850a-18fb3e21b96c_600x600_i?s=21618c9c3183ffded748d303a253b637"),
    BackendRequestMapperWithImage("J.C.Staff", "J.C.Staff", image: "https://cdn.myanimelist.net/s/common/company_logos/076ec06c-a090-41b5-971e-2fc2ae446f5e_600x600_i?s=5872ea7d2c75469d2d296574a5c8c1fb"),
    BackendRequestMapperWithImage("Bones", "Bones", image: "https://cdn.myanimelist.net/s/common/company_logos/969047f0-a8ec-475e-ad0d-6e0d5cd8e17f_600x600_i?s=4145bdb95a29f3fe1447baa8045a7420"),
    BackendRequestMapperWithImage("Production I.G", "Production I.G", image: "https://cdn.myanimelist.net/s/common/company_logos/5b86997d-226e-4870-ae60-e353a78178a0_600x600_i?s=0db04e298454b4278acfb8a2c60c7001"),
    BackendRequestMapperWithImage("Kyoto Animation", "Kyoto Animation", image: "https://cdn.myanimelist.net/s/common/company_logos/b066ff17-81d3-40db-b1f2-2927de70c0e3_600x600_i?s=edb149cf051e2d7984975063a1b3b3a7"),
    BackendRequestMapperWithImage("MAPPA", "MAPPA", image: "https://cdn.myanimelist.net/s/common/company_logos/e3a5163d-3b09-4e98-922b-79180a75539f_600x600_i?s=3289c478fd611569ebccd7ff076151df"),
    BackendRequestMapperWithImage("ufotable", "ufotable", image: "https://cdn.myanimelist.net/s/common/company_logos/03171393-4a85-451d-a025-4a3f05d1aede_600x600_i?s=48ebfd25c277dd148d41f88568f60aa6"),
    BackendRequestMapperWithImage("Wit Studio", "Wit Studio", image: "https://cdn.myanimelist.net/s/common/company_logos/e7e64f9e-23f6-4c74-9813-cb4fcdb600cf_600x600_i?s=37f6a1b3342db61d87d4e50803fd6fd6"),
    BackendRequestMapperWithImage("Studio Ghibli", "Studio Ghibli", image: "https://cdn.myanimelist.net/s/common/company_logos/e6d02dfe-71e9-49d2-bef1-68e585c2605e_600x600_i?s=f8bba4a0f7ae97f80c95e463c7529bd6"),
    BackendRequestMapperWithImage("Shaft", "Shaft", image: "https://cdn.myanimelist.net/s/common/company_logos/6abfb420-5815-4a62-b978-cbbf9b868fa0_600x600_i?s=5fe7fdaf8e4e09c14c58d7ac6fc29f80"),
    BackendRequestMapperWithImage("CloverWorks", "CloverWorks", image: "https://cdn.myanimelist.net/s/common/company_logos/75875b81-17bb-4f7e-a06f-bb149d54687e_600x600_i?s=b90a570d03511f70dbac7e04869f4835"),
    BackendRequestMapperWithImage("Trigger", "Trigger", image: "https://cdn.myanimelist.net/s/common/company_logos/bc3f892a-8581-45b1-8a95-81b6ac518f3d_600x600_i?s=d2a2e7f05478dbb999b17d35c44445db"),
    BackendRequestMapperWithImage("Toei Animation", "Toei Animation", image: "https://cdn.myanimelist.net/s/common/company_logos/33d49515-685a-4133-8ad3-41b09197e88d_600x600_i?s=cd6405cb06051286ce2bfbd4ce645443"),
    BackendRequestMapperWithImage("Aniplex", "Aniplex", image: "https://cdn.myanimelist.net/s/common/company_logos/ba2241ea-7f83-45b6-9360-1f1d4de0d65a_600x600_i?s=369f1423117062ab3c7f4c7a90b2005a"),
    BackendRequestMapperWithImage("Gainax", "Gainax", image: "https://cdn.myanimelist.net/s/common/company_logos/7bba2118-127e-47a3-855f-0b284689f3da_600x600_i?s=c62c0bef4c82c81b750746955a423f64"),
    BackendRequestMapperWithImage("White Fox", "White Fox", image: "https://cdn.myanimelist.net/s/common/company_logos/40ba3310-9602-47fc-beb2-cc346adada09_600x600_i?s=6e3600896f107186d1a8dad0a3222d43"),
    BackendRequestMapperWithImage("Sunrise", "Sunrise", image: "https://cdn.myanimelist.net/s/common/company_logos/6a9279a7-1aeb-4a2b-bceb-4e7f24fae7b1_600x600_i?s=3550689bfb655805cd6d4d3b3987cc91"),
    BackendRequestMapperWithImage("Crunchyroll", "Crunchyroll", image: "https://cdn.myanimelist.net/s/common/company_logos/73f4abea-0377-4362-8bb2-6d6577e9d303_600x600_i?s=30e237ce4c86b2874096c79521c492d2"),
    BackendRequestMapperWithImage("Kadokawa", "Kadokawa", image: "https://cdn.myanimelist.net/s/common/company_logos/8a7cb4eb-caa6-46e1-8997-cb1e1ea5ffd2_600x600_i?s=c040c830a2425bb0a280e1f751c43b09"),
  ];

  //TODO: Add like EA, Bethesta etc.
  static final GamePopularPublishersList = [];

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
    NameUrl("Discover", "https://image.tmdb.org/t/p/w300/odVlTMqPPiMksmxpN9cCbPCjUPP.jpg"),
    NameUrl("Action", "https://www.themoviedb.org/t/p/w300/xVXbesCdNt37b3Kh6d3FgOtdajB.jpg"),
    NameUrl("Adventure", "https://www.themoviedb.org/t/p/w300/mBxsapX4DNhH1XkOlLp15He5sxL.jpg"),
    NameUrl("Avant Garde", "https://www.themoviedb.org/t/p/w300/fGXhmKyqRmx6NN3gQHeWNmiEryl.jpg"),
    NameUrl("Award Winning", "https://www.themoviedb.org/t/p/w300/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg"),
    NameUrl("Comedy", "https://www.themoviedb.org/t/p/w300/s0w8JbuNNxL1YgaHeDWih12C3jG.jpg"),
    NameUrl("Drama", "https://www.themoviedb.org/t/p/w300/mMtUybQ6hL24FXo0F3Z4j2KG7kZ.jpg"),
    NameUrl("Fantasy", "https://www.themoviedb.org/t/p/w300/dTFnU3EQB79aDM4HnUj06Y9Xbq1.jpg"),
    NameUrl("Horror", "https://www.themoviedb.org/t/p/w300/yOarY3Yo0NMkuTuft87M5oAZa3C.jpg"),
    NameUrl("Mystery", "https://www.themoviedb.org/t/p/w300/rRGnjRCHdDl3m3oCVSvo5z2E5c5.jpg"),
    NameUrl("Romance", "https://www.themoviedb.org/t/p/w300/dRGtv7BLMe00RAxtLkaWjcbzsTA.jpg"),
    NameUrl("Sci-Fi", "https://www.themoviedb.org/t/p/w300/36Ech63X2KU8JUXIBAo167kIC2k.jpg"),
    NameUrl("Slice of Life", "https://www.themoviedb.org/t/p/w300/4xvQGRIJpPEDf7HQdF0JkBVsmoX.jpg"),
    NameUrl("Sports", "https://www.themoviedb.org/t/p/w300/12mYMPE7Jy7rhDv0rn95GEtF94V.jpg"),
    NameUrl("Supernatural", "https://www.themoviedb.org/t/p/w300/kP5duNJEbTfXpBs6CITsaZ88pQi.jpg"),
    NameUrl("Suspense", "https://www.themoviedb.org/t/p/w300/uAjMQlbPkVHmUahhCouANlHSDW2.jpg"),
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
    BackendRequestMapper("❄️ Winter", "winter"),
    BackendRequestMapper("☀️ Summer", "summer"),
    BackendRequestMapper("🍁 Fall", "fall"),
    BackendRequestMapper("🌸 Spring", "spring"),
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

  static final MoviePopularCountries = [
    BackendRequestMapper("U.S.A.", "US"),
    BackendRequestMapper("Japan", "JP"),
    BackendRequestMapper("France", "FR"),
    BackendRequestMapper("Great Britain", "GB"),
    BackendRequestMapper("Korea", "KR"),
    BackendRequestMapper("Canada", "CA"),
    BackendRequestMapper("Germany", "DE"),
    BackendRequestMapper("Italy", "IT"),
    BackendRequestMapper("Spain", "ES"),
    BackendRequestMapper("India", "IN"),
    BackendRequestMapper("Belgium", "BE"),
    BackendRequestMapper("Hong Kong", "HK"),
    BackendRequestMapper("China", "CN"),
    BackendRequestMapper("Russia", "RU"),
    BackendRequestMapper("Turkey", "TR"),
  ];

  static final TVPopularCountries = [
    BackendRequestMapper("U.S.A.", "US"),
    BackendRequestMapper("Korea", "KR"),
    BackendRequestMapper("Great Britain", "GB"),
    BackendRequestMapper("Japan", "JP"),
    BackendRequestMapper("Canada", "CA"),
    BackendRequestMapper("Hong Kong", "HK"),
    BackendRequestMapper("France", "FR"),
    BackendRequestMapper("Germany", "DE"),
    BackendRequestMapper("China", "CN"),
    BackendRequestMapper("Brazil", "BR"),
    BackendRequestMapper("Russia", "RU"),
    BackendRequestMapper("Australia", "AU"),
    BackendRequestMapper("Italy", "IT"),
    BackendRequestMapper("Spain", "ES"),
    BackendRequestMapper("Turkey", "TR"),
    BackendRequestMapper("Philippines", "PH"),
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