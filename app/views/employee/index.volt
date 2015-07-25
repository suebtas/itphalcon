<div class="row-fluid">
	<h1 class="text-center">การจัดการข้อมูลด้วยเฟรมเวิร์ด Phalcon, Bootstrap และ jQuery</h1><hr><br>
	<div class="col-md-8 col-md-offset-2">
		<!--botón que abre una modal para añadir un nuevo post-->
		<a href="#" class="btn btn-success add pull-right" onclick="crudPhalcon.add()">เพิ่มโพสต์</a><br><hr>
		<table class="table table-striped table-bordered table-condensed text-center">
			<thead>
				<tr>
					<th class="text-center">รหัส SSN</th>
		            <th class="text-center">ชื่อ</th>
		            <th class="text-center">สกุล</th>
		            <th class="text-center">แผนก</th>
		            <th class="text-center">แก้ไข</th>
		            <th class="text-center">ลบ</th>
		        </tr>
			</thead>
			<tbody>
	        <?php 
	        //ตรวจสอบค่าในตาราง Employee ว่ามีข้อมูล เพื่อ items คือค่าที่ได้จากคำสั่ง Select * from Employee limit 1,5 
	        if(count($page->items) > 0)
	        {
	        	//ตัวแปรคลาส page คือค่าที่ได้จาก $paginator->getPaginate();  ภายใต้ indexAction ที่อยู่ใน EmployeeController.php
	        	//ที่ตัวแปร items ได้จากคำสั่ง Select * from Employee limit 1,5 
		        foreach ($page->items as $employee) 
		        { 
		        ?>
		        <tr>
		            <td><?php echo $employee->SSN; ?></td>
		            <td><?php echo $employee->FNAME; ?></td>
		            <td><?php echo $employee->LNAME; ?></td>
		            <td><?php echo $employee->department->DNAME; ?></td>
		            <td>
		            	<!--สร้างการตรวจสอบการลิงค์ด้วยเงื่อนไข onclick ด้วย javascript เพื่อเรียกใช้เมธอด edit ที่ทำงานภายใต้อ็อฟเจ็ค crudPhalcon โดยเอาค่าข้อมูลจากตัว $employee  ที่มีตัวแปร SSN , FNAME, LNAME, DNO ไปสร้าง FORM-->
			            <a href="#" class="btn btn-info edit" 
			            onclick="crudPhalcon.edit('<?php echo htmlentities(json_encode($employee)) ?>')">
			            	แก้ไข
			            </a>
		            </td>
		            <td>
		            	<!--สร้างการตรวจสอบการลิงค์ด้วยเงื่อนไข onclick ด้วย javascript เพื่อเรียกใช้เมธอด delete ที่ทำงานภายใต้อ็อฟเจ็ค crudPhalcon โดยเอาค่าข้อมูลจากตัว $employee  ที่มีตัวแปร SSN , FNAME, LNAME, DNO ไปสร้าง FORM-->
			            <a href="#" class="btn btn-danger delete" 
			            onclick="crudPhalcon.delete('<?php echo htmlentities(json_encode($employee)) ?>')">	
			            	ลบ
			            </a>
		            </td>
		        </tr>
		        <?php 
		        } 
		        ?>
			    </tbody>
			<?php
			}
			//si no hay posts
			else
			{
			?>
			<tbody>
				<tr>
		            <td colspan="6">
		            	<div class="alert alert-danger alert-dismissable text-center">
		            		ขณะนี้มีการโพสต์ไม่มี
		            	</div>
		            </td>
		        </tr>
		    </tbody>
			<?php
			}
			?>
		</table>
		<?php 
		//แสดงส่วนการแบ่งหน้าจอ ถ้าข้อมูลที่ได้จากคำสั่ง Select * from Employee  มีค่ามากกว่า 0
	    if(count($page->items) > 0)
	    {
	    ?>
		<center>
		<ul class="pagination pagination-lg pager">
            <li>{{link_To(["employee/index", 'หน้าแรก', "class" : "btn"])}}</li>
            <li>{{link_To(["employee/index?page="~page.before, 'ก่อนหน้า'])}}</li>
            <li>{{link_To(["employee/index?page="~page.next, 'ถัดไป'])}}</li>
            <li>{{link_To(["employee/index?page="~page.last, 'หน้าสุดท้าย'])}}</li>
		</ul>
		<p><?php echo "หน้า", $page->current, " จาก ", $page->total_pages; ?></p>
		</center>
		<?php
		}
		?>
	</div>
</div>
<script type="text/javascript">
//ใช้ javascript สร้างตัวแปรอ็อฟเจ็ค crudPhalcon เพื่อเก็บเมธอด 
//add() 	เมธอดเพื่อแสดง Modal ฟอร์ม HTML เพิ่มข้อมูล
//edite()  	เมธอดเพื่อแสดง Modal ฟอร์ม HTML แก้ไขข้อมูล
//delete() 	เมธอดเพื่อแสดง Modal ฟอร์ม HTML ลบข้อมูล
//parse() 	เมธอดรับค่าข้อมูลจาก Ajax
//addPost()	เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/add ที่ส่งข้อมูลแบบ POST
//editPost()	เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/edit ที่ส่งข้อมูลแบบ POST
//deletePost()	เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/delete ที่ส่งข้อมูลแบบ GET
var crudPhalcon = {};
$(document).ready(function()
{
	//สร้างฟอร์มสร้างข้อมูลโพสต์
	crudPhalcon.add = function()
	{
		var html = "";
		$("#modalCrudPhalcon .modal-title").html("สร้างโพสต์ใหม่");
		$("#onclickBtn").attr("onclick","crudPhalcon.addPost()").text("สร้าง").show();
		$("#modalCrudPhalcon .modal-body").load("{{url('employee/newform')}}");
		$("#modalCrudPhalcon").modal("show");
	},	
	//เมธอดเพื่อแสดง Modal ฟอร์ม HTML แก้ไขข้อมูล
	//วิธีการผ่านค่าข้อมูล crudPhalcon.edit('{"SSN":"999887777","FNAME":"ALICIA","MINIT":"J","LNAME":"ZELAYA","BDATE":"1958-06-19 00:00:00","ADDRESS":"3321 CASTKE, SPRING, TX","SEX":"F","SALARY":"25000","SUPERSSN":"987654321","DNO":"4","department":{"DNUMBER":"4","DNAME":"ADMINISTRATION","MGRSSN":"987654321","MGRSTARTDATE":"1995-01-01 00:00:00"}}')

	crudPhalcon.edit = function(post)	//สร้างฟอร์มแก้ไขข้อมูลโพสต์
	{
		//สร้างตัวแปรออฟเจ็ค จากข้อความสตริง รูปแบบ json ที่ได้จากตาราง employee		

		var json = crudPhalcon.parse(post), html = "";
		$("#modalCrudPhalcon .modal-title").html("แก้ไข " + json.title);

		$("#modalCrudPhalcon .modal-body").load("{{url('employee/editform/')}}"+json.SSN);
		$("#onclickBtn").attr("onclick","crudPhalcon.editPost()").text("แก้ไข").show();
		//$("#modalCrudPhalcon .modal-body").html(html);
		$("#modalCrudPhalcon").modal("show");
	},
	//เมธอดเพื่อแสดง Modal ฟอร์ม HTML ลบข้อมูล
	crudPhalcon.delete = function(employee) //สร้างฟอร์มลบข้อมูลโพสต์
	{
		var json = crudPhalcon.parse(employee), html = "";
		$("#modalCrudPhalcon .modal-title").html("ลบ " + json.FNAME + ' ' +json.LNAME);
		html += "<p class='alert alert-warning'>คุณแน่ใจหรือว่าต้องการลบโพสต์หรือไม่</div>";
		$("#onclickBtn").attr("onclick","crudPhalcon.deletePost('"+json.SSN+"')").text("ยืนยัน").show();
		$("#modalCrudPhalcon .modal-body").html(html);
		$("#modalCrudPhalcon").modal("show");
	},
	//เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/add ที่ส่งข้อมูลแบบ POST
	crudPhalcon.addPost = function()
	{
		$.ajax({
			url: "{{url('employee/add')}}",
			data: $("#form").serialize(),
			method: "POST",
			success: function(data)
			{
				$("#modalCrudPhalcon .modal-body").html("").html(
					"<p class='alert alert-success'>บันทึกโพสต์สำเร็จ</p>"
				);
				$("#onclickBtn").hide();
			},
			error: function(error)
			{
				console.log(error);
			}
		});
	},
	//เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/edit ที่ส่งข้อมูลแบบ POST
	crudPhalcon.editPost = function()//สร้างเมธอด editPost()
	{
		$.ajax({
			url: "<?php echo $this->url->get('employee/edit') ?>",
			data: $("#form").serialize(),
			method: "POST",
			success: function(data)
			{
				
				var val=crudPhalcon.parse(data);
				if(val != ''){
					$("#modalCrudPhalcon .modal-body").html("").html(
						"<p class='alert alert-success'>โพสต์ปรับปรุงเรียบร้อย</p>"
					);
					$("#onclickBtn").hide();				
					$("body").load("{{url("employee/index?page="~request.getQuery('page', 'int'))}}");
				}else{
					$("#modalCrudPhalcon .modal-body").html("").html(
					"<p class='alert alert-warning'>พบข้อผิดพลาด</p>"
					);
					$("#onclickBtn").hide();
					//console.log(data);
				}
			},
			error: function(error)
			{
				console.log(error);
			}
		})
	},
	//เมธอดส่งข้อมูล Ajax ไปให้ http://localhost/employee/delete ที่ส่งข้อมูลแบบ GET ด้วยค่ารหัส SSN
	crudPhalcon.deletePost = function(id)
	{
		$.ajax({
			url: "<?php echo $this->url->get('employee/delete') ?>",
			data: "SSN="+id,
			method: "GET",
			success: function(data)
			{
				$("#modalCrudPhalcon .modal-body").html("").html(
					"<p class='alert alert-success'>โพสต์ลบเรียบร้อยแล้ว</p>"
				);
				$("#onclickBtn").hide();
			},
			error: function(error)
			{
				console.log(error);
			}
		});
	},
	//ใช้แปลงค่า สตริง เป็นค่าออฟเจ็ค
	crudPhalcon.parse = function(post)
	{
		try{
			data = JSON.parse(post);
		}catch(err){
			data = "";
		}
		return data;
	},
	//สร้าง input เก็บค่า token เพื่อใช้การส่งข้อมูลแต่ละฟอร์มที่ ใช้ในการแก้ไข และ ลบข้อมูล
	crudPhalcon.csrfProtection = function()
	{
		return '<input type="hidden" name="<?php echo $this->security->getTokenKey() ?>"'+
        	   'value="<?php echo $this->security->getToken() ?>"/>';
	}
});
</script>
<!--ส่วนแสดงข้อมูล modal ที่อยู่ใน Framework bootstrap สำหรับแสดง FORM เพิ่ม แ้ไข และ ลบ-->
<div class="modal fade" id="modalCrudPhalcon" tabindex="-1" role="dialog" aria-labelledby="modalCrudPhalconLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title"></h4>
        </div>
        <div class="modal-body">

        </div>
        <div class="modal-footer">
        	<button type="button" id="onclickBtn" class="btn btn-success">ส่ง</button>
            <button type="button" class="btn btn-danger" data-dismiss="modal">ปิด</button>
        </div>
      </div>
    </div>
</div>
