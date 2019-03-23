<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>CastAnalysis</title>

    <link rel="shortcut icon" type="image/x-icon" href="/Template/assets/img/logo.png" />

    <link href="/Template/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

    <link href="/Template/assets/css/main.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/responsive.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/icons.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700' rel='stylesheet' type='text/css'>

    <script type="text/javascript" src="/Template/assets/js/libs/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>

    <script type="text/javascript" src="/Template/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/Template/assets/js/libs/lodash.compat.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/touchpunch/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.move.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.swipe.js"></script>

    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">

        var googleUserId = "<%: ViewBag.User.GoogleID %>";
        var accountId = "<%: ViewBag.AccountID %>";

        var appReady = false;

        var sessions = [];

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http) {

            $scope.signOut = function () {

                location.href = "/";

            };

            var CLIENT_ID = '246693846494-mgm7c9nqvvkt34qqvpshj6chanc8en9h.apps.googleusercontent.com';

            var SCOPES = ['https://www.googleapis.com/auth/analytics.readonly'];

            $scope.init = function () {

                $scope.header = "Last Year's Monthly Data";

                $scope.authorize();

            };

            $scope.authorize = function () {

                var authData = {
                    client_id: CLIENT_ID,
                    scope: SCOPES,
                    immediate: true
                };

                gapi.auth.authorize(authData, function (response) { $scope.queryAccounts(); });

            };

            $scope.queryAccounts = function () {

                gapi.client.load('analytics', 'v3').then(function () {
                    gapi.client.analytics.management.accounts.list().then($scope.handleAccounts);
                });

            };

            $scope.handleAccounts = function (response) {

                $scope.accounts = response.result.items;
                $scope.$apply();

                if (response.result.items && response.result.items.length) {
                    var firstAccountId = response.result.items[0].id;
                    $scope.queryProperties(firstAccountId);
                } else {
                    console.log('No accounts found for this user.');
                }

            };

            $scope.queryProperties = function (accountId) {
                gapi.client.analytics.management.webproperties.list(
                    { 'accountId': accountId })
                  .then($scope.handleProperties)
                  .then(null, function (err) {
                      console.log(err);
                  });
            };

            $scope.handleProperties = function (response) {

                if (response.result.items && response.result.items.length) {
                    var firstAccountId = response.result.items[0].accountId;
                    var firstPropertyId = response.result.items[0].id;
                    $scope.queryProfiles(firstAccountId, firstPropertyId);
                } else {
                    console.log('No properties found for this user.');
                }

            };

            $scope.queryProfiles = function (accountId, propertyId) {

                gapi.client.analytics.management.profiles.list({
                    'accountId': accountId,
                    'webPropertyId': propertyId
                })
                .then($scope.handleProfiles)
                .then(null, function (err) {
                    console.log(err);
                });
            };

            $scope.handleProfiles = function (response) {
                if (response.result.items && response.result.items.length) {
                    var firstProfileId = response.result.items[0].id;
                    $scope.queryCoreReportingApi(firstProfileId);
                } else {
                    console.log('No views (profiles) found for this user.');
                }
            };

            $scope.queryCoreReportingApi = function (profileId) {

                gapi.client.analytics.data.ga.get({
                    'ids': 'ga:' + profileId,
                    'start-date': '2015-01-01',
                    'end-date': '2016-12-30',
                    'metrics': 'ga:pageviews',
                    'dimensions': 'ga:pageTitle,ga:deviceCategory,ga:date'
                })
                .then(function (response) {

                    sessions = response.result.rows;

                    console.log(JSON.stringify(sessions));

                    $scope.pages = [];

                    var exists = false;

                    for (var i = 0; i < sessions.length; i++) {

                        for (var j = 0; j < $scope.pages.length; j++) {

                            if ($scope.pages[j] == sessions[i][0] || $scope.pages[j] == "Main Page") {
                                exists = true;
                                break;
                            }

                        }

                        if (exists) {
                            exists = false;
                            continue;
                        }
                        else {

                            if (sessions[i][0] == "/")
                                $scope.pages.push("Main Page");
                            else
                                $scope.pages.push(sessions[i][0]);

                        }

                        $scope.currentPage = $scope.pages[0];

                        $scope.$apply();

                    }

                    appReady = true;

                })
                .then(null, function (err) {
                    console.log(err);
                });
            }

            $scope.draw = function (page, span) {

                $scope.currentPage = page;

                if (page == "Main Page")
                    page = "/";

                if (span == "year")
                    $scope.header = "Last Year's Monthly Data";
                else if ("year2")
                    $scope.header = "Last 2 Year's Monthly Data";

                Reorganize(page, "desktop", span);
                Graph("#desktopChart", "blue", "Total Desktop Views");

                Reorganize(page, "mobile", span);
                Graph("#mobileChart", "green", "Total Mobile Views");

            };

        });

    </script>

    <script type="text/javascript" src="/Template/assets/js/libs/breakpoints.js"></script>
    <script type="text/javascript" src="/Template/plugins/respond/respond.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/cookie/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.horizontal.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/sparkline/jquery.sparkline.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.tooltip.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.resize.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.time.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.growraf.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/easy-pie-chart/jquery.easy-pie-chart.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/daterangepicker/moment.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/daterangepicker/daterangepicker.js"></script>
    <script type="text/javascript" src="/Template/plugins/blockui/jquery.blockUI.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/fullcalendar/fullcalendar.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/noty/jquery.noty.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/layouts/top.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/themes/default.js"></script>

    <script type="text/javascript" src="/Template/plugins/uniform/jquery.uniform.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/select2/select2.min.js"></script>

    <script type="text/javascript" src="/Template/assets/js/app.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.form-components.js"></script>

    <script>

        var data = [];

        function Reorganize(page, type, span) {

            var currentYear = new Date().getFullYear();

            var month = 0, year = 0, count = 0;

            var dic = {};

            data = [];

            for (var i = 0; i < sessions.length; i++) {

                if (span == "year")
                    month = parseInt(sessions[i][2].substr(4, 2));
                else if (span == "year2") {

                    year = parseInt(sessions[i][2].substr(0, 4));

                    if (year == currentYear)
                        month = parseInt(sessions[i][2].substr(4, 2)) + 12;
                    else if (year == currentYear - 1)
                        month = parseInt(sessions[i][2].substr(4, 2));
                }

                count = parseInt(sessions[i][3]);

                if (sessions[i][0] == page && sessions[i][1] == type) {

                    if (dic[month] == null)
                        dic[month] = 0;

                    dic[month] += count;

                }

            }

            for (var key in dic) {

                data.push([parseInt(key), dic[key]]);

            }

        }

        function Graph(id, color, caption) {

            var min = 25;
            var max = -12;

            for (var i = 0; i < data.length; i++) {

                if (data[i][0] < min)
                    min = data[i][0];

                if (data[i][0] > max)
                    max = data[i][0];

            }

            if (min >= 1)
                min = 0;

            if (max < 12)
                max = 12;

            if (max >= 12)
                max++;

            var graph = [
                { label: caption, data: data, color: App.getLayoutColorCode(color) }
            ];

            $.plot(id, graph, $.extend(true, {}, Plugins.getFlotDefaults(), {
                xaxis: {
                    min: min,
                    max: max,
                    tickSize: 1,
                    ticks: [
                        [-11, "Jan"], [-10, "Feb"], [-9, "Mar"], [-8, "Apr"], [-7, "May"], [-6, "Jun"], [-5, "Jul"], [-4, "Aug"], [-3, "Sep"], [-2, "Oct"], [-1, "Nov"], [0, "Dec"],
                        [1, "Jan"], [2, "Feb"], [3, "Mar"], [4, "Apr"], [5, "May"], [6, "Jun"], [7, "Jul"], [8, "Aug"], [9, "Sep"], [10, "Oct"], [11, "Nov"], [12, "Dec"],
                        [13, "Jan"], [14, "Feb"], [15, "Mar"], [16, "Apr"], [17, "May"], [18, "Jun"], [19, "Jul"], [20, "Aug"], [21, "Sep"], [22, "Oct"], [23, "Nov"], [24, "Dec"]
                    ]
                },
                series: {
                    lines: {
                        fill: false,
                        lineWidth: 1
                    },
                    points: {
                        show: true,
                        radius: 2.5,
                        lineWidth: 1
                    },
                    grow: { active: true, growings: [{ stepMode: "maximum" }] }
                },
                grid: {
                    hoverable: true,
                    clickable: true
                },
                tooltip: true,
                tooltipOpts: {
                    content: '%s: %y'
                }
            }));

        }

        function Start() {

            if (appReady) {

                App.init();
                Plugins.init();
                FormComponents.init();

                $("#charts").css("display", "initial");

                Reorganize("/", "desktop", "year");
                Graph("#desktopChart", "blue", "Total Desktop Views");

                Reorganize("/", "mobile", "year");
                Graph("#mobileChart", "green", "Total Mobile Views");

            }
            else {
                setTimeout(function () { Start(); }, 1000);
            }

        }

        Start();

    </script>

</head>
<body ng-app="fc" ng-controller="Ctrl" id="body">

    <header class="header navbar navbar-fixed-top" role="banner">

        <div class="container">
            <ul class="nav navbar-nav">
                <li class="nav-toggle"><a href="javascript:void(0);" title=""><i class="icon-reorder"></i></a></li>
            </ul>

            <a class="navbar-brand" href="index.html">
                <img src="/Template/assets/img/logo.png" alt="logo" />
                <strong>CastAnalysis</strong>
            </a>

            <ul class="nav navbar-nav navbar-left hidden-xs hidden-sm">
                <li>
                    <a href="/Page/Account/<%: ViewBag.AccountID %>">
                        <i class="fa fa-database"></i>
                        Current Data
                    </a>
                </li>
                <li>
                    <a href="/Page/Analysis/<%: ViewBag.AccountID %>">
                        <i class="fa fa-line-chart"></i>
                        Future Analysis
                    </a>
                </li>
            </ul>

            <ul class="nav navbar-nav navbar-right">

                <li class="dropdown">
                    <a href="#" class="project-switcher-btn dropdown-toggle" ng-click="expand()">
                        <i class="fa fa-globe"></i>
                        <span>Accounts</span>
                    </a>
                </li>

                <li class="dropdown user">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="icon-male"></i>
                        <span class="username"><%: ViewBag.User.Name %></span>
                        <i class="icon-caret-down small"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="#" ng-click="signOut()"><i class="icon-key"></i>Log Out</a></li>
                    </ul>
                </li>
            </ul>
        </div>

        <div id="project-switcher" class="container project-switcher">
            <div id="scrollbar">
                <div class="handle"></div>
            </div>

            <div id="frame">
                <ul class="project-list">
                    <li ng-repeat="account in accounts">
                        <a href="/Page/Account/{{account.id}}">
                            <span class="image"><i class="icon-male"></i></span>
                            <span class="title">{{account.name}}</span>
                        </a>
                    </li>
                </ul>
            </div>

        </div>

    </header>

    <div id="container">

        <div id="sidebar" class="sidebar-fixed">
            <div id="sidebar-content">

                <!--=== Navigation ===-->
                <ul id="nav">
                    <li ng-repeat="page in pages">
                        <a href="#">
                            <i class="icon-globe"></i>{{page}}</a>
                        <ul class="sub-menu">
                            <li>
                                <a href="#" ng-click="draw(page,'year')">
                                    <i class="icon-angle-right"></i>
                                    Last Year's Data
                                </a>
                            </li>
                            <li>
                                <a href="#" ng-click="draw(page,'year2')">
                                    <i class="icon-angle-right"></i>
                                    Last 2 Year's Data
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>

            </div>
            <div id="divider" class="resizeable"></div>
        </div>

        <div id="content">



            <div class="container">

                <div class="crumbs">
                    <ul id="breadcrumbs" class="breadcrumb">
                        <li>
                            <i class="icon-home"></i>
                            <a href="#">Current Data</a>
                        </li>
                        <li class="current">
                            <a href="#" title="">{{currentPage}}</a>
                        </li>
                    </ul>
                </div>

                <div class="row" id="charts" style="display: none">
                    <div class="col-md-6">
                        <div class="widget box">
                            <div class="widget-header">
                                <h4><i class="icon-desktop"></i>{{header}}</h4>
                                <div class="toolbar no-padding">
                                    <div class="btn-group">
                                        <span class="btn btn-xs widget-collapse"><i class="icon-angle-down"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div id="desktopChart" class="chart"></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="widget box">
                            <div class="widget-header">
                                <h4><i class="icon-mobile-phone"></i>{{header}}</h4>
                                <div class="toolbar no-padding">
                                    <div class="btn-group">
                                        <span class="btn btn-xs widget-collapse"><i class="icon-angle-down"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div id="mobileChart" class="chart"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <script type="text/javascript">

        function init() {

            angular.element(document.getElementById("body")).scope().init();

        }

    </script>

    <script src="https://apis.google.com/js/client.js?onload=init"></script>
</body>
</html>
