<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!doctype html>
<html lang="en">
<!--begin::Head-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>어드민페이지</title>
<!--begin::Primary Meta Tags-->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="title" content="Main Header Component | AdminLTE 4" />
<meta name="author" content="ColorlibHQ" />
<meta name="description"
	content="AdminLTE is a Free Bootstrap 5 Admin Dashboard, 30 example pages using Vanilla JS." />
<meta name="keywords"
	content="bootstrap 5, bootstrap, bootstrap 5 admin dashboard, bootstrap 5 dashboard, bootstrap 5 charts, bootstrap 5 calendar, bootstrap 5 datepicker, bootstrap 5 tables, bootstrap 5 datatable, vanilla js datatable, colorlibhq, colorlibhq dashboard, colorlibhq admin dashboard" />
<!--end::Primary Meta Tags-->
<!--begin::Fonts-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@fontsource/source-sans-3@5.0.12/index.css"
	integrity="sha256-tXJfXfp6Ewt1ilPzLDtQnJV4hclT9XuaZUKyUvmyr+Q="
	crossorigin="anonymous" />
<!--end::Fonts-->
<!--begin::Third Party Plugin(OverlayScrollbars)-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.10.1/styles/overlayscrollbars.min.css"
	integrity="sha256-tZHrRjVqNSRyWg2wbppGnT833E/Ys0DHWGwT04GiqQg="
	crossorigin="anonymous" />
<!--end::Third Party Plugin(OverlayScrollbars)-->
<!--begin::Third Party Plugin(Bootstrap Icons)-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	integrity="sha256-9kPW/n5nn53j4WMRYAxe9c1rCY96Oogo/MKSVdKzPmI="
	crossorigin="anonymous" />
<!--end::Third Party Plugin(Bootstrap Icons)-->
<!--begin::Required Plugin(AdminLTE)-->
<link rel="stylesheet" href="/css/adminlte.css" />
<!--end::Required Plugin(AdminLTE)-->
<style>
	[data-astro-image] {
		width: 100%;
		height: auto;
		object-fit: var(- -fit);
		object-position: var(- -pos);
		aspect-ratio: var(- -w)/var(- -h);
	}
	
	[data-astro-image='responsive'] {
		max-width: calc(var(- -w)* 1px);
		max-height: calc(var(- -h)* 1px);
	}
	
	[data-astro-image='fixed'] {
		width: calc(var(- -w)* 1px);
		height: calc(var(- -h)* 1px);
	}
</style>
</head>
<!--end::Head-->
<!--begin::Body-->
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
	<!--begin::App Wrapper-->
	<div class="app-wrapper">
		<!--begin::Header-->
		<nav class="app-header navbar navbar-expand bg-body">
			<!--begin::Container-->
			<div class="container-fluid">
				<!--begin::End Navbar Links-->
				<ul class="navbar-nav ms-auto">
					<!--begin::User Menu Dropdown-->
					<li class="nav-item dropdown user-menu"><a href="#"
						class="nav-link dropdown-toggle" data-bs-toggle="dropdown"> <img
							src="${userInfo.memProfile}"
							class="user-image rounded-circle shadow" alt="User Image" />
							<span class="d-none d-md-inline">${userInfo.memName}</span>
					</a>
					<!--end::User Menu Dropdown-->
				</ul>
				<!--end::End Navbar Links-->
			</div>
			<!--end::Container-->
		</nav>
		<!--end::Header-->
		<!--begin::Sidebar-->
		<aside class="app-sidebar bg-body-secondary shadow"
			data-bs-theme="dark">
			<!--begin::Sidebar Brand-->
			<div class="sidebar-brand">
				<!--begin::Brand Link-->
				<a href="/" class="brand-link"> 
					<span class="brand-text fw-light">모두가농부</span>
				</a>
				<!--end::Brand Link-->
			</div>
			<!--end::Sidebar Brand-->
			<!--begin::Sidebar Wrapper-->
			<div class="sidebar-wrapper">
				<nav class="mt-2">
					<!--begin::Sidebar Menu-->
					<ul class="nav sidebar-menu flex-column" data-lte-toggle="treeview"
						role="menu" data-accordion="false">
						<li class="nav-item">
							<ul class="nav nav-treeview" style="display:block;">
								<li class="nav-item">
									<a href="/admin/main" class="nav-link"> 
										<i class="nav-icon bi bi-circle"></i>
										<p>메인</p>
									</a>
								</li>
								<li class="nav-item">
									<a href="/admin/member"	class="nav-link"> 
										<i class="nav-icon bi bi-circle"></i>
										<p>회원상세</p>
									</a>
								</li>
								<li class="nav-item">
									<a href="/admin/prod" class="nav-link"> 
										<i class="nav-icon bi bi-circle"></i>
										<p>상품상세</p>
									</a>
								</li>
							</ul>
						</li>
					</ul>
					<!--end::Sidebar Menu-->
				</nav>
			</div>
			<!--end::Sidebar Wrapper-->
		</aside>
		<!--end::Sidebar-->
		
		<div class="card">
			<div class="card-header">
				<h3 class="card-title">거래작물 순위</h3>
			</div>
			<!-- /.card-header -->
			<div class="card-body p-0" style="max-height: 580px;">
				<div class="table-responsive" style="max-height: 580px; overflow-y: auto;">
					<table class="table m-0">
						<thead>
							<tr>
								<th>상품 종류</th>
								<th>거래중</th>
								<th>거래완료</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="cnt" items="${cntList}">
								<tr>
									<td>${cnt.prodCategory}</td>
									<td>${cnt.otherCount}</td>
									<td>${cnt.comCount}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.card-body -->
		</div>
	</div>
</body>
<script src="/js/adminlte.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</html>
