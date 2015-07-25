{{form("employee/edit", "method":"post", "id" :"form")}}
{{hidden_field('token','name':security.getTokenKey(),'value':security.getToken())}}
<label>รหัส SSN</label>
 {{ text_field("SSN", "class": "form-control") }}
<label>ชื่อ</label>
 {{ text_field("FNAME", "class": "form-control") }}
<label class="control-label">สกุล</label>
 {{ text_field("LNAME", "class": "form-control") }}
<label class="control-label">แผนก</label>
{{select('DNO',department,'using':['DNUMBER','DNAME'],'class':'form-control')}}
{{ tag_html_close("form") }}