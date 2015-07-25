<?php

//โหลดคลาส QueryBuilder ให้ชื่อเป็น PaginacionBuilder เพื่อใช้สร้างการแบ่งหน้าจอข้อมูล
use \Phalcon\Paginator\Adapter\QueryBuilder as PaginacionBuilder;

class EmployeeController extends ControllerBase
{

	/**
	* @desc - สำหรับแสดงข้อมูลพนักงาน
	* @return object
	*/
    public function indexAction()
    {
    	//สร้างคลาสตัวแปร สำหรับสร้างคำสั่ง SQL เพื่อคิวรี่ Select * from Employee
        $employees = $this->modelsManager->createBuilder()
	    ->from('Employee')
	    ->orderBy('SSN');

	    //กำหนดเงื่อนไขการโหลดข้อมูลจากตาราง Employee ครั้งละ 5 แถว ด้วยเงื่อนไข limit เช่น Select * from Employee limit 1,5 
		$paginator = new PaginacionBuilder(array(
		    "builder" => $employees,
		    "limit"=> 5,
		    "page" => $this->request->getQuery('page', 'int')
		));
 		
        //ส่งข้อมูลสู่ View ภายใต้ตัวแปร page สำหรับแสดงผลบนหน้าเว็บ
        $this->view->page = $paginator->getPaginate();
    }

	/**
	* @desc - สร้างฟอร์มสำหรับใส่ข้อมูลพนักงานใหม่
	* @return object
	*/
	public function newFormAction(){
		$this->view->department = Department::find();
	}

	/**
	* @desc - สร้างฟอร์มสำหรับ่ข้อมูลพนักงานที่เรียกดู
	* @return object
	*/
	public function editFormAction($SSN){
		$employee = Employee::findFirst(array("conditions"=>"SSN=?0","bind"=>array($SSN)));
		$this->tag->setDefault('SSN',$employee->SSN);
		$this->tag->setDefault('FNAME',$employee->FNAME);
		$this->tag->setDefault('LNAME',$employee->LNAME);
		$this->tag->setDefault('DNO',$employee->DNO);
		$this->view->department = Department::find();
	}
    /**
	* @desc - สำหรับรับค่าข้อมูล FORM ที่ส่งค่าข้อมูลจาก AJax แบบ Post
	* @return json
	*/
    public function addAction()
    {
    	//ปิดการใช้งานสำหรับการร้องขอ Ajax
        $this->view->disable();

        //ถ้ากดปุ่มโพสต์
        if($this->request->isPost() == true) 
        {
            //ถ้าส่งฝ่าน Ajax
            if($this->request->isAjax() == true) 
            {
            	////อนุญาตให้ส่งข้อมูลครั้งเดียวโดยใช้เงื่อนไขของ  token ตรวจสอบ
            	if($this->security->checkToken()) 
            	{
            		// สร้าง Model ข้อมูลตาราง Employee รับค่าข้อมูลจากการส่งข้อมูลภายใต้  FORM ที่มีส่งข้อมูล SSN, FNAME, LNAME, DNO
		        	$employee = new Employee();
	                $employee->SSN = $this->request->getPost('SSN', array('striptags', 'trim'));
	                $employee->FNAME = $this->request->getPost('FNAME', array('striptags', 'trim'));
	                $employee->LNAME = $this->request->getPost('LNAME', array('striptags', 'trim'));
	                $employee->DNO = $this->request->getPost('DNO', array('striptags', 'trim'));
	                //รันคำสั่ง SQL insert into employee (SSN, FNAME, LNAME, DNO) value ($_POST['SSN'] ,$_POST['FNAME'] ...)
	                if($employee->save())
	                {
	                	$this->response->setJsonContent(array("res"	=>	"success"));
				        //ระบุสถานะทำงานเสร็จโดยค่า Code 200 เพื่อส่งข้อมูลการทำงานสำเร็จ
				        $this->response->setStatusCode(200, "OK");
	                }
	                else
	                {
	                	$this->response->setJsonContent(array("res"	=>	"error")); 
				        //ระบุสถานะทำงานผิดพลาดโดยค่า Code 500 เพื่อส่งข้อมูลการทำงานผิดพลาด
				        $this->response->setStatusCode(500, "Internal Server Error");
	                }
				    $this->response->send();
	            }
            }
        }
    }

    /**
	* @desc - รับค่าการกดปุ่มแก้ไข ที่มีการส่งข้อมูลแบบ POST
	* @return json
	*/
    public function editAction()
    {
    	//ไม่แสดง view
        $this->view->disable();
 
        //อนุญาตให้รับข้อมูลแบบ POST เท่านั้น
        if($this->request->isPost() == true) 
        {
            //อนุญาตให้ส่งผ่านวิธี Ajax เท่านั้น
            if($this->request->isAjax() == true) 
            {
            	////อนุญาตให้ส่งข้อมูลครั้งเดียวโดยใช้เงื่อนไขของ  token ตรวจสอบ
            	if($this->security->checkToken()) 
            	{
            		$parameters = array(
			            "SSN" => $this->request->getPost('SSN')
			        );

		        	$employee = Employee::findFirst(array(
			            "SSN = :SSN:",
			            "bind" => $parameters
			        ));

	                $employee->FNAME = $this->request->getPost('FNAME', array('striptags', 'trim'));
	                $employee->LNAME = $this->request->getPost('LNAME', array('striptags', 'trim'));
	                $employee->DNO = $this->request->getPost('DNO', array('striptags', 'trim'));
	                //รันคำสั่ง SQL update Employee set FNAME=$_POST['FNAME'], LNAME=$_POST['LNAME'] where SSN=$_POST['SSN']
	                if($employee->update())
	                {
	                	$this->response->setJsonContent(array( "res"	=>	"success"));
				        //ระบุสถานะทำงานเสร็จโดยค่า Code 200 เพื่อส่งข้อมูลการทำงานสำเร็จ
				        $this->response->setStatusCode(200, "OK");
	                }
	                else
	                {
	                	$this->response->setJsonContent(array("res"	=>	"error")); 
				        //ระบุสถานะทำงานผิดพลาดโดยค่า Code 500 เพื่อส่งข้อมูลการทำงานผิดพลาด
				        $this->response->setStatusCode(500, "Internal Server Error");
	                }
				    $this->response->send();
	            }
            }
        }
    }

    /**
	* @desc - รับค่าการกดปุ่มลบ ที่มีการส่งข้อมูลแบบ GET
	* @return json
	*/
    public function deleteAction()
    {
    	//ไม่แสดง view
        $this->view->disable();
 
        //อนุญาตให้รับข้อมูลแบบ GET เท่านั้น
        if($this->request->isGet() == true) 
        {
            //อนุญาตให้ส่งผ่านวิธี Ajax เท่านั้น
            if($this->request->isAjax() == true) 
            {
            	//โหลดข้อมูลจากตาราง Employee ภายใต้เงื่อนไข select * from Employee where SSN= $_GET['SSN']
	        	$employee = Employee::findFirst(array("conditions"=>"SSN=?0","bind"=>array($this->request->get("SSN"))));

	        	//จะทำการลบเมื่อพบค่าข้อมูในตาราง Employee เท่านั้น
				if($employee != false) 
				{
	                //รันคำสั่ง SQL delete from Employee where SSN=$_GET['SSN']
				    if($employee->delete() != false) 
				    {
	                	$this->response->setJsonContent(array( "res"	=>	"success"));
				        //ระบุสถานะทำงานเสร็จโดยค่า Code 200 เพื่อส่งข้อมูลการทำงานสำเร็จ
				        $this->response->setStatusCode(200, "OK");
	                }
	                else
	                {
	                	$this->response->setJsonContent(array( "res"	=>	"error")); 
				        //ระบุสถานะทำงานผิดพลาดโดยค่า Code 500 เพื่อส่งข้อมูลการทำงานผิดพลาด
				        $this->response->setStatusCode(500, "Internal Server Error");
	                }
	            }
			    $this->response->send();
            }
        }
    }
}
//Location: app/controllers EmpoyeeController.php
