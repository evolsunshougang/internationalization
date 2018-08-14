#coding=utf-8
import os
import os.path
import shutil
rootdir = "./source"

file_count=0
for parent,dirnames,filenames in os.walk(rootdir):  
#    for dirname in  dirnames:                       #输出文件夹信息
#        print "parent is:" + parent
#        print  "dirname is" + dirname
        
    for filename in filenames:                        #输出文件信息
        if filename.find('Mapper')>0:
            file_count=file_count+1
            model_name=filename[0:filename.index('Mapper')]
            service_name='I'+model_name+'Service'
            impl_name=model_name+'ServiceImpl'
            controller_name=model_name+'Controller'
                        
            fimpl = open('./impl/'+impl_name+'.java', 'w')
            fimpl.write("package com.cicpay.gateway.base.service.impl;\n")
            fimpl.write("import com.cicpay.gateway.base.dao.I"+model_name+"Dao;\n")
            fimpl.write("import com.cicpay.gateway.base.model."+model_name+";\n")
            fimpl.write("import com.cicpay.gateway.base.service."+service_name+";\n")
            fimpl.write("import org.springframework.stereotype.Service;\n")            
        
            fimpl.write("import javax.annotation.Resource;\n")                        
            fimpl.write("\n")
            fimpl.write("@Service\n")            
            fimpl.write("public class "+impl_name+" implements "+service_name+" {\n")            
            fimpl.write("\n")
            fimpl.write("   @Resource\n")
            fimpl.write("   private I"+model_name+"Dao dao;\n")

            fcontroller = open('./controller/'+controller_name+'.java', 'w')
            fcontroller.write("package com.cicpay.gateway.base.controller; \n")   
            
            fcontroller.write("import com.cicpay.gateway.base.model.JsonResult;\n")
            fcontroller.write("import com.cicpay.gateway.base.model.PubRole;\n")
            fcontroller.write("import com.cicpay.gateway.base.service.IPubRoleService;\n")
            fcontroller.write("import org.springframework.stereotype.Controller;\n")
            fcontroller.write("import org.springframework.web.bind.annotation.RequestMapping;\n")
            fcontroller.write("import org.springframework.web.bind.annotation.RequestMethod;\n")
            fcontroller.write("import org.springframework.web.bind.annotation.ResponseBody;\n")
            fcontroller.write("import java.util.ArrayList;\n")
            fcontroller.write("import java.util.List;\n")
            fcontroller.write("import javax.servlet.http.HttpServletRequest;\n")
            fcontroller.write("import javax.servlet.http.HttpServletResponse;\n")
            fcontroller.write("import javax.annotation.Resource;\n")
            fcontroller.write("import com.cicpay.gateway.base.service."+service_name+";\n")
            fcontroller.write("import com.cicpay.gateway.base.model."+model_name+";\n")
            fcontroller.write("/**\n")
            fcontroller.write(" * Created by beifeitu on 16/9/16.\n")
            fcontroller.write(" */\n")
            fcontroller.write("@Controller\n")
            fcontroller.write("@RequestMapping(value = \""+model_name+"\")\n")
            fcontroller.write("public class "+controller_name+" extends BaseController {\n")
            fcontroller.write("\n")
            fcontroller.write("     @Resource\n")
            fcontroller.write("     private "+service_name+" service;\n")
            fcontroller.write("\n")
            
            fsock = open('./target/'+service_name+'.java', 'w')
            fsock.write("package com.cicpay.gateway.base.service;\n")
            fsock.write("import com.cicpay.gateway.base.model."+model_name+";\n")            
            fsock.write("public interface "+service_name+" {\n")            
              
            file_object = open(os.path.join(parent,filename))
            try:
                write=0
                lines=file_object.readlines()
                for line in lines:
                    #print line.find('abdddd')
                    if write==1:
                        fsock.write(line)
                        if len(line)>5:
                            method=line.replace(';','{').replace('  ','')
                            method_split= method.split(' ')
#                            print method_split
                            method_name= method_split[1].split('(')
                            parameter_splite= method_split[2].split(')')
                            fimpl.write('   public '+method+"\n")
                            fimpl.write("       return this.dao."+method_name[0]+"("+parameter_splite[0]+");\n")                            
                            fimpl.write("   }\n")
                            fimpl.write("\n")
                            
                          #  print method_name
                            fcontroller.write("     @RequestMapping(value = {\""+method_name[0]+"\"}, method = RequestMethod.POST)\n")
                            fcontroller.write("     @ResponseBody\n")
                            fcontroller.write('     public JsonResult '+method_name[0]+" (HttpServletRequest request, HttpServletResponse response){\n")
                            fcontroller.write("         JsonResult jsonResult = new JsonResult();\n")
                            fcontroller.write("         jsonResult.setCode(\"\");\n")
                            fcontroller.write("         jsonResult.setMsg(\"\");\n")
                            fcontroller.write("         jsonResult.setSumCount(0);\n")
                            if method_name[1]!="String":
                                fcontroller.write("         "+method_name[1]+" parmenter=("+method_name[1]+")parameterChange(request,"+method_name[1]+".class);\n")
                                #fcontroller.write("         "+method_name[1]+" parmenter=new "+method_name[1]+"();\n")                   
                                fcontroller.write("         jsonResult.setDatas(service."+method_name[0]+"(parmenter));\n")            
                            else:
                                fcontroller.write("         "+method_name[1]+" "+parameter_splite[0]+"=request.getParameter(\""+parameter_splite[0]+"\");\n")    
                                fcontroller.write("         jsonResult.setDatas(service."+method_name[0]+"("+parameter_splite[0]+"));\n")
                            fcontroller.write("         return jsonResult;\n")                            
                            fcontroller.write("    }\n")
                            fcontroller.write("\n")                            
                            
                        
                                                        
                    if line.find('}')>0:
                        write=0
                    if line.find('{')>0:
                        write=1
                        
                    #print line 
                 #all_the_text = file_object.read()
                 #print all_the_text
            finally:
                 file_object.close()
             
            fsock.close()
            fimpl.write("   }\n")            
            fimpl.close() 
            
            fcontroller.write("    @RequestMapping(value = {\"findAll\"}, method = RequestMethod.POST)\n")
            fcontroller.write("    @ResponseBody\n")
            fcontroller.write("    public JsonResult findAll(HttpServletRequest request, HttpServletResponse response) {\n")
            fcontroller.write("        JsonResult jsonResult = new JsonResult();\n")
            fcontroller.write("        String keyword = request.getParameter(\"keyword\");\n")
            fcontroller.write("        jsonResult.setCode(\"\");\n")
            fcontroller.write("        jsonResult.setMsg(\"\");\n")
            fcontroller.write("        jsonResult.setSumCount(0);\n")
            fcontroller.write("        List<"+model_name+"> list = new ArrayList<>();\n")
            fcontroller.write("        jsonResult.setDatas(list);\n")
            fcontroller.write("        return jsonResult;\n")
            fcontroller.write("    }\n")
            
            fcontroller.write("    @RequestMapping(value = \"index\")\n")
            fcontroller.write("    public String index(HttpServletRequest request, HttpServletResponse response) {\n")
            fcontroller.write("        return \""+model_name.lower()+"/index\";\n")
            fcontroller.write("    }\n")
            
            fcontroller.write("}\n")    
            fcontroller.close()
            if os.path.exists("./jsp/"+model_name.lower())==False:
                os.mkdir("./jsp/"+model_name.lower());     
            shutil.copy("./index.jsp",  "./jsp/"+model_name.lower())
            #print "parent is:" + parent
            #print "filename is:" + filename
            print "the full name of the file is comploted:" + os.path.join(parent,filename) #输出文件路径信息
print 'completed file count='+str(file_count)
