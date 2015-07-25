
<div class="container">
	<div class="jumbotron">
	<h1>Congratulations!</h1>

	<p>You're now flying with Phalcon. Great things are about to happen!</p>
	</div>
</div>
<div class="container">
	<div class="row">
	{%for department in departments %}
		<div class="col-md-4">			
			<h1>{{department.DNAME}}</h1>
			<h3>Super SSN</h3>
			<p>{{department.employee.FNAME}} {{department.employee.LNAME}}</p>
			<a href="#" class="btn btn-default">แสดงโครงงานในแผนก {{department.DNAME}} </a>
		</div>
	{%endfor%}
	</div>
</div>
<div class="container">
<h1>รายการพนักงาน</h1>
<table class="table table-bordered">
	<thead>
	<tr><th colspan=2>ชื่อ-สกุล</th><th>ที่อยู่</th></tr>
	</thead>
	<tbody>
	{%for employee in employees %}
	<tr>
		<td>{{employee.FNAME}}</td><td>{{employee.LNAME}}</td><td>{{employee.ADDRESS}}</td>
	</tr>
	{% endfor%}
	</tbody>
</table>
</div>