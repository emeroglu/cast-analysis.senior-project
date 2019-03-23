<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>CastAnalysis</title>

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

    <script src="/Scripts/regression.js"></script>
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

                $scope.header = "Next Month's Projection";

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
                    'dimensions': 'ga:pagePath,ga:deviceCategory,ga:date'
                })
                .then(function (response) {

                    sessions = response.result.rows;

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

                    }

                    $scope.currentPage = $scope.pages[0];

                    $scope.$apply();

                    appReady = true;

                })
                .then(null, function (err) {
                    console.log(err);
                });
            }

            $scope.draw = function (page, project) {

                $scope.currentPage = page;

                if (page == "Main Page")
                    page = "/";

                if (project == "month")
                    $scope.header = "Next Month's Projection";
                else if (project == "month3")
                    $scope.header = "Next 3 Month's Projection";
                else if (project == "year")
                    $scope.header = "Next Year's Projection";

                Reorganize(page, "desktop");                
                Graph("#desktopChart", "blue", "Total Desktop Views", project, Forecast());

                Reorganize(page, "mobile");                
                Graph("#mobileChart", "green", "Total Mobile Views", project, Forecast());

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

    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/mathjs/3.2.1/math.min.js"></script>

    <script>

        var data = [];

        function Reorganize(page, type) {

            data = [];

            var month = 0, count = 0;

            var dic = {};

            for (var i = 0; i < sessions.length; i++) {

                month = parseInt(sessions[i][2].substr(4, 2));
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

        function Forecast() {

            var rawData = [], forecast = [];

            for (var i = 0; i < data.length; i++) {
                rawData.push(data[i]);
            }

            var result = regression('polynomial', rawData, 4);                                    

            return result.points;

        }

        function LinearRegression(feed) {

            var X, Y, Z, inv_Z, sudo_inv_X, W;

            var x = [];
            var y = [];

            for (var i = 0; i < feed.length; i++) {

                x.push([feed[i][0]]);
                y.push([feed[i][1]]);

            }

            X = math.matrix(x);
            Y = math.matrix(y);

            Z = math.multiply(math.transpose(X), X);

            inv_Z = math.inv(Z);

            sudo_inv_X = math.multiply(inv_Z, math.transpose(X));

            W = math.multiply(sudo_inv_X, Y);

            return { W: W, X: X, Y: Y };

        }

        function Graph(id, color, caption, project, forecast) {

            var appendix = 0;
            var projection = [];

            if (project == "month") {

                projection = [forecast[0]];

                appendix = 2;

            }
            else if (project == "month3") {

                projection = [
                    forecast[0],
                    forecast[1],
                    forecast[2]
                ];

                appendix = 4;
            }
            else if (project == "year") {

                appendix = 13;

                projection = forecast;

            }

            var graph = [
                { label: caption, data: data, color: App.getLayoutColorCode(color) },
                { label: "Projection", data: projection, color: App.getLayoutColorCode("red") }
            ];

            $.plot(id, graph, $.extend(true, {}, Plugins.getFlotDefaults(), {
                xaxis: {
                    min: 0,
                    max: 12 + appendix,
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

                $("#chart1").css("display", "initial");
                $("#chart2").css("display", "initial");
               
                Reorganize("/", "desktop");
                Graph("#desktopChart", "blue", "Total Desktop Views", "month", Forecast());

                Reorganize("/", "mobile");
                Graph("#mobileChart", "green", "Total Mobile Views", "month", Forecast());

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
                        <li><a href="#" ng-click="logout()"><i class="icon-key"></i>Log Out</a></li>
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
                                <a href="#" ng-click="draw(page,'month')">
                                    <i class="icon-angle-right"></i>
                                    Next Month's Projection
                                </a>
                            </li>
                            <li>
                                <a href="#" ng-click="draw(page,'month3')">
                                    <i class="icon-angle-right"></i>
                                    Next 3 Month's Projection
                                </a>
                            </li>
                            <li>
                                <a href="#" ng-click="draw(page,'year')">
                                    <i class="icon-angle-right"></i>
                                    Next Year's Projection
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
                            <a href="#">Future Analysis</a>
                        </li>
                        <li class="current">
                            <a href="#" title="">{{currentPage}}</a>
                        </li>
                    </ul>
                </div>

                <div class="row" id="chart1" style="display: none">
                    <div class="col-md-12">
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
                </div>
                <div class="row" id="chart2" style="display: none">
                    <div class="col-md-12">
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
