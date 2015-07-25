{{form("employee/add", "method":"post", "id" :"form")}}
{{hidden_field('token','name':security.getTokenKey(),'value':security.getToken())}}
<label>รหัส SSN</label>
<input type="text" name="SSN" class="form-control">
<label>ชื่อ</label>
<input type="text" name="FNAME" class="form-control">
<label class="control-label">สกุล</label>
<textarea class="form-control" name="LNAME" rows="3"></textarea>
<label class="control-label">แผนก</label>
{{select('DNO',department,'using':['DNUMBER','DNAME'],'class':'form-control')}}
{{ tag_html_close("form") }}