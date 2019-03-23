<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>CastAnalysis | <%: (ViewBag.User != null)?Html.Raw(ViewBag.User.Name):"" %></title>

    <link href="/Template/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

    <!-- jQuery UI -->
    <!--<link href="plugins/jquery-ui/jquery-ui-1.10.2.custom.css" rel="stylesheet" type="text/css" />-->
    <!--[if lt IE 9]>
		<link rel="stylesheet" type="text/css" href="plugins/jquery-ui/jquery.ui.1.10.2.ie.css"/>
	<![endif]-->

    <!-- Theme -->
    <link href="/Template/assets/css/main.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/responsive.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/icons.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <!--[if IE 7]>
		<link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome-ie7.min.css">
	<![endif]-->

    <!--[if IE 8]>
		<link href="/Template/assets/css/ie8.css" rel="stylesheet" type="text/css" />
	<![endif]-->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700' rel='stylesheet' type='text/css'>

    <!--=== JavaScript ===-->

    <script type="text/javascript" src="/Template/assets/js/libs/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>

    <script type="text/javascript" src="/Template/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/Template/assets/js/libs/lodash.compat.min.js"></script>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
		<script src="/Template/assets/js/libs/html5shiv.js"></script>
	<![endif]-->

    <!-- Smartphone Touch Events -->
    <script type="text/javascript" src="/Template/plugins/touchpunch/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.move.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.swipe.js"></script>

    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">

        var appReady = false;

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http) {

            $http.get("/Service/AllWebsites").success(function (data) {

                $scope.websites = data;

                $http.get("/Service/AllCompanyMembers/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.fcCompany.PK):"" %>").success(function (data) {

                    $scope.members = data;

                    appReady = true;

                });

            });

            $scope.logout = function () {

                $http.get("/Service/LogTheUserOut/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>").success(function (data) {

                    location.href = "/Page/Login";

                });

            };

        });

    </script>

    <!-- General -->
    <script type="text/javascript" src="/Template/assets/js/libs/breakpoints.js"></script>
    <script type="text/javascript" src="/Template/plugins/respond/respond.min.js"></script>
    <!-- Polyfill for min/max-width CSS3 Media Queries (only for IE8) -->
    <script type="text/javascript" src="/Template/plugins/cookie/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.horizontal.min.js"></script>

    <!-- Page specific plugins -->
    <!-- Charts -->
    <!--[if lt IE 9]>
		<script type="text/javascript" src="plugins/flot/excanvas.min.js"></script>
	<![endif]-->
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

    <!-- Noty -->
    <script type="text/javascript" src="/Template/plugins/noty/jquery.noty.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/layouts/top.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/themes/default.js"></script>

    <!-- Forms -->
    <script type="text/javascript" src="/Template/plugins/uniform/jquery.uniform.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/select2/select2.min.js"></script>

    <!-- App -->
    <script type="text/javascript" src="/Template/assets/js/app.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.form-components.js"></script>

    <script>

        Start();

        function Start() {

            if (appReady) {
                App.init(); // Init layout and core plugins
                Plugins.init(); // Init all plugins
                FormComponents.init(); // Init all form-specific plugins
            }
            else {
                setTimeout(function () { Start(); }, 1000);
            }

        }
    </script>

</head>
<body ng-app="fc" ng-controller="Ctrl">
    <header class="header navbar navbar-fixed-top" role="banner">
        <!-- Top Navigation Bar -->
        <div class="container">

            <!-- Only visible on smartphones, menu toggle -->
            <ul class="nav navbar-nav">
                <li class="nav-toggle"><a href="javascript:void(0);" title=""><i class="icon-reorder"></i></a></li>
            </ul>

            <!-- Logo -->
            <a class="navbar-brand" href="index.html">
                <img src="/Template/assets/img/logo.png" alt="logo" />
                <strong><%: (ViewBag.Website != null)?Html.Raw(ViewBag.Website.Name):"Cast" %></strong><%: (ViewBag.Website != null)?"":"Analysis" %>
            </a>
            <!-- /logo -->

            <!-- Top Right Menu -->
            <ul class="nav navbar-nav navbar-right">

                <!-- Project Switcher Button -->
                <li class="dropdown">
                    <a href="#" class="project-switcher-btn dropdown-toggle">
                        <i class="fa fa-globe"></i>
                        <span>Websites</span>
                    </a>
                </li>

                <!-- User Login Dropdown -->
                <li class="dropdown user">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <!--<img alt="" src="/Template/assets/img/avatar1_small.jpg" />-->
                        <i class="icon-male"></i>
                        <span class="username"><%: (ViewBag.User != null)?Html.Raw(ViewBag.User.Username):"" %></span>
                        <i class="icon-caret-down small"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="/Page/Profile/<%: (ViewBag.User != null)?ViewBag.User.PK:"" %>"><i class="icon-user"></i>Profile</a></li>
                        <li class="divider"></li>
                        <li><a href="#" ng-click="logout()"><i class="icon-key"></i>Log Out</a></li>
                    </ul>
                </li>
                <!-- /user login dropdown -->
            </ul>
            <!-- /Top Right Menu -->
        </div>
        <!-- /top navigation bar -->

        <!--=== Project Switcher ===-->
        <div id="project-switcher" class="container project-switcher">
            <div id="scrollbar">
                <div class="handle"></div>
            </div>

            <div id="frame">
                <ul class="project-list">
                    <li ng-repeat="website in websites">
                        <a href="/Page/Website/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>/{{website.pk}}">
                            <span class="image"><i class="icon-male"></i></span>
                            <span class="title">{{website.name}}</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!-- /#frame -->
        </div>
        <!-- /#project-switcher -->


    </header>

    <div id="container" class="fixed-header">

        <div id="sidebar" class="sidebar-fixed">
            <div class="slimScrollDiv" style="position: relative; overflow: hidden; width: auto; height: 100%;">
                <div id="sidebar-content" style="overflow: hidden; width: auto; height: 100%;">

                    <!--=== Navigation ===-->
                    <ul id="nav">
                        <li class="current">
                            <a href="index.html">
                                <i class="icon-dashboard"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0);">
                                <i class="icon-desktop"></i>
                                UI Features
							<span class="label label-info pull-right">6</span>
                                <i class="arrow icon-angle-left"></i></a>
                            <ul class="sub-menu">
                                <li>
                                    <a href="ui_general.html">
                                        <i class="icon-angle-right"></i>
                                        General
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_buttons.html">
                                        <i class="icon-angle-right"></i>
                                        Buttons
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_tabs_accordions.html">
                                        <i class="icon-angle-right"></i>
                                        Tabs &amp; Accordions
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_sliders.html">
                                        <i class="icon-angle-right"></i>
                                        Sliders
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_nestable_list.html">
                                        <i class="icon-angle-right"></i>
                                        Nestable List
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_typography.html">
                                        <i class="icon-angle-right"></i>
                                        Typography / Icons
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_google_maps.html">
                                        <i class="icon-angle-right"></i>
                                        Google Maps
                                    </a>
                                </li>
                                <li>
                                    <a href="ui_grid.html">
                                        <i class="icon-angle-right"></i>
                                        Grid
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="javascript:void(0);">
                                <i class="icon-edit"></i>
                                Form Elements
						<i class="arrow icon-angle-left"></i></a>
                            <ul class="sub-menu">
                                <li>
                                    <a href="form_components.html">
                                        <i class="icon-angle-right"></i>
                                        Form Components
                                    </a>
                                </li>
                                <li>
                                    <a href="form_layouts.html">
                                        <i class="icon-angle-right"></i>
                                        Form Layouts
                                    </a>
                                </li>
                                <li>
                                    <a href="form_validation.html">
                                        <i class="icon-angle-right"></i>
                                        Form Validation
                                    </a>
                                </li>
                                <li>
                                    <a href="form_wizard.html">
                                        <i class="icon-angle-right"></i>
                                        Form Wizard
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="javascript:void(0);">
                                <i class="icon-table"></i>
                                Tables
						<i class="arrow icon-angle-left"></i></a>
                            <ul class="sub-menu">
                                <li>
                                    <a href="tables_static.html">
                                        <i class="icon-angle-right"></i>
                                        Static Tables
                                    </a>
                                </li>
                                <li>
                                    <a href="tables_dynamic.html">
                                        <i class="icon-angle-right"></i>
                                        Dynamic Tables (DataTables)
                                    </a>
                                </li>
                                <li>
                                    <a href="tables_responsive.html">
                                        <i class="icon-angle-right"></i>
                                        Responsive Tables
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="charts.html">
                                <i class="icon-bar-chart"></i>
                                Charts &amp; Statistics
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0);">
                                <i class="icon-folder-open-alt"></i>
                                Pages
						<i class="arrow icon-angle-left"></i></a>
                            <ul class="sub-menu">
                                <li>
                                    <a href="login.html">
                                        <i class="icon-angle-right"></i>
                                        Login
                                    </a>
                                </li>
                                <li>
                                    <a href="pages_user_profile.html">
                                        <i class="icon-angle-right"></i>
                                        User Profile
                                    </a>
                                </li>
                                <li>
                                    <a href="pages_calendar.html">
                                        <i class="icon-angle-right"></i>
                                        Calendar
                                    </a>
                                </li>
                                <li>
                                    <a href="pages_invoice.html">
                                        <i class="icon-angle-right"></i>
                                        Invoice
                                    </a>
                                </li>
                                <li>
                                    <a href="404.html">
                                        <i class="icon-angle-right"></i>
                                        404 Page
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="javascript:void(0);">
                                <i class="icon-list-ol"></i>
                                4 Level Menu
						<i class="arrow icon-angle-left"></i></a>
                            <ul class="sub-menu">
                                <li class="open-default">
                                    <a href="javascript:void(0);">
                                        <i class="icon-cogs"></i>
                                        Item 1
									<span class="arrow"></span>
                                        <i class="arrow icon-angle-down"></i></a>
                                    <ul class="sub-menu">
                                        <li class="open-default">
                                            <a href="javascript:void(0);">
                                                <i class="icon-user"></i>
                                                Sample Link 1
											<span class="arrow"></span>
                                                <i class="arrow icon-angle-down"></i></a>
                                            <ul class="sub-menu">
                                                <li class="current"><a href="javascript:void(0);"><i class="icon-remove"></i>Sample Link 1</a></li>
                                                <li><a href="javascript:void(0);"><i class="icon-pencil"></i>Sample Link 1</a></li>
                                                <li><a href="javascript:void(0);"><i class="icon-edit"></i>Sample Link 1</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="javascript:void(0);"><i class="icon-user"></i>Sample Link 1</a></li>
                                        <li><a href="javascript:void(0);"><i class="icon-external-link"></i>Sample Link 2</a></li>
                                        <li><a href="javascript:void(0);"><i class="icon-bell"></i>Sample Link 3</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="javascript:void(0);">
                                        <i class="icon-globe"></i>
                                        Item 2
									<span class="arrow"></span>
                                        <i class="arrow icon-angle-left"></i></a>
                                    <ul class="sub-menu">
                                        <li><a href="javascript:void(0);"><i class="icon-user"></i>Sample Link 1</a></li>
                                        <li><a href="javascript:void(0);"><i class="icon-external-link"></i>Sample Link 1</a></li>
                                        <li><a href="javascript:void(0);"><i class="icon-bell"></i>Sample Link 1</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="javascript:void(0);">
                                        <i class="icon-folder-open"></i>
                                        Item 3
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>

                    <div class="fill-nav-space"></div>
                </div>
                <div class="slimScrollBar" style="width: 7px; position: absolute; top: 0px; opacity: 0.4; display: none; border-radius: 7px; z-index: 99; right: 1px; height: 630.783px; background: rgb(0, 0, 0);"></div>
                <div class="slimScrollRail" style="width: 7px; height: 100%; position: absolute; top: 0px; display: none; border-radius: 7px; opacity: 0.2; z-index: 90; right: 1px; background: rgb(51, 51, 51);"></div>
            </div>
            <div id="divider" class="resizeable"></div>
        </div>

        <div id="content">
            <div class="container">

                <!--=== Page Header ===-->
                <div class="page-header">
                    <div class="page-title">
                        <h3><%: (ViewBag.User != null)?ViewBag.User.Name + " " + ViewBag.User.Surname:"" %></h3>
                        <span><%: (ViewBag.User != null)?ViewBag.User.fcCompany.Name:"" %></span>
                    </div>

                </div>
                <!-- /Page Header -->

                <!--=== Page Content ===-->
                <!--=== Inline Tabs ===-->
                <div class="row">
                    <div class="col-md-12">
                        <!-- Tabs-->
                        <div class="tabbable tabbable-custom tabbable-full-width">
                            <div class="tab-content row">
                                <!--=== Overview ===-->
                                <div class="tab-pane active" id="tab_overview">
                                    <div class="col-md-3">
                                        <div class="list-group">
                                            <li class="list-group-item no-padding">
                                                <img src="<%: (ViewBag.User != null)?ViewBag.User.Picture:"" %>" alt="">
                                            </li>
                                        </div>
                                    </div>

                                    <div class="col-md-9">
                                        <div class="row profile-info">
                                            <div class="col-md-12">
                                                <div class="widget box">
                                                    <div class="widget-header">
                                                        <h4><i class="icon-reorder"></i>Far Beyond Members</h4>
                                                        <div class="toolbar no-padding">
                                                            <div class="btn-group">
                                                                <span class="btn btn-xs widget-collapse"><i class="icon-angle-down"></i></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="widget-content">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>First Name</th>
                                                                    <th>Last Name</th>
                                                                    <th>Status</th>                                                                                                                                      
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr ng-repeat="member in members">
                                                                    <td>{{member.index}}</td>
                                                                    <td>{{member.name}}</td>
                                                                    <td>{{member.surname}}</td>
                                                                    <td>
                                                                        <span class="label label-success" ng-if="member.online">Online</span>
                                                                        <span class="label label-danger" ng-if="!member.online">Offline</span>
                                                                    </td>                                                                                                                                        
                                                                </tr>                                                               
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <!-- /Simple Table -->
                                            </div>
                                        </div>
                                        <!-- /.row -->

                                    </div>
                                    <!-- /.col-md-9 -->
                                </div>
                                <!-- /Overview -->
                            </div>
                            <!--END TABS-->
                        </div>
                    </div>
                    <!-- /.row -->
                    <!-- /Page Content -->
                </div>
                <!-- /.container -->

            </div>

        </div>

    </div>

</body>
</html>
