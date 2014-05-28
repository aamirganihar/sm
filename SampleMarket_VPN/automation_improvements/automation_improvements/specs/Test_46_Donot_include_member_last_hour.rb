# DO NOT INCLUDE MEMBER WHO SIGNED UP IN LAST ONE HOUR

require 'rubygems'
require 'watir'
require 'Usamp_lib'
require 'test/unit'
#Load WATIR
require 'fileutils'
# Load WIN32OLE library
require 'win32ole' 
require 'Win32API'
#Load the win32 library
require 'win32/clipboard'
include Win32
#include 'Suite'
require 'base64'
require 'Input Repository\Test_46_Donot_include_member_last_hour_Input.rb'

class Test_46_Donot_include_member_last_hour < Test::Unit::TestCase

			$wd=Dir.pwd
			$proj_id_file_path = $wd+"/Input Repository/Project_ID.txt"
			$qg_id_file_path = $wd+"/Input Repository/QG_ID.txt"
			$out_fl_path = $wd+"/Output Repository/Non4S_Test_Report.html"
  
      def test_01_report_head
	  
				$t = "46 - "
				$test_description = "Test Case: "+$t.to_s+"  DO NOT INCLUDE MEMBER WHO SIGNED UP IN LAST ONE HOUR"
				$obj = Usamp_lib.new
				$obj.Test_report($test_description)
								
	  end
	  
	  def test_02_qg_setup
				
			begin	
				$st = "1"
				#$test_id = $t.to_s+"."+$st.to_s
				$test_description = "Enabling setting at QG level "
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$file_1 = File.open($proj_id_file_path)
				$prj_id = $file_1.gets
				puts $prj_id
				$file_1.close;
			
				$file_2 = File.open($qg_id_file_path)
				$qg_id = $file_2.gets
				puts $qg_id
				$file_2.close;
					
				$prj_n = Base64.encode64($prj_id)
				$qg_n = Base64.encode64($qg_id)
					
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				$ie.goto("p.usampadmin.com/add_quota_group.php?project_id=#{$prj_n}&quota_group_id=#{$qg_n}")
				$ie.select_list(:name, "optQuotaStatus").set("Open")
				$ie.button(:name,"btnSave").click
				sleep 2
				$ie.checkbox(:id, "chkExcludeMembers").set
				$ie.text_field(:id, "txtExcludeMembersHours").set($hours)
				$ie.button(:value,"Save Group").click
				if($ie.contains_text(/Quota group details have been updated successfully/) && $ie.checkbox(:id, "chkExcludeMembers").isSet?)
					puts 'Pass'
					$myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
				else
					puts 'Fail'   
					$myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
				end
				
				$ie.link(:text,'Logout').click
				$obj.Delete_cookies
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$myfile.print "<td class=\"td3\"><font color=\"black\">NOT COMPLETED SUCCESSFULY!{Please check the log for details}</font></td></tr>"
			end	
	  end
	  
	  def test_03_member_signup_check_survey
				
			begin	
				$st = "2"
				#$test_id = $t.to_s+"."+$st.to_s
				$test_description = "Survey not shown immediately after member sign up "
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ff = FireWatir::Firefox.new
				$ff.goto("p.surveyhead.com/recaptcha_automation_proxy.php?mode=test")
				$ff.goto("p.surveyhead.com/registration_step1.php")
				$ff.text_field(:name, "txtFname").set("AUTO FNAME")
				$ff.text_field(:name, "txtLname").set("AUTO LNAME")
                $ff.select_list(:name, "optCountryId").set($country)
                $ff.select_list(:name, "optLanguageId").set($lang)
                sleep 7
                $ff.select_list(:name, "optStateId").set($state)
                sleep 2
                $ff.text_field(:name, "txtZipPostal").set($zip_match)
                $ff.select_list(:name, "optNonUSDayId").set($day)
                $ff.select_list(:name, "optNonUSMonthId").set($month)
                $ff.select_list(:name, "optNonUSYearId").set($year)
                $ff.radio(:value, "Male").set
				$extension = Time.new
                $extension = $extension.to_s
                $extension = $extension.slice(0..18)
                $mail_address="auto_test.des"+$extension+"@mailinator.com"
                $mail_address = $mail_address.gsub(/:/, "")
                $mail_address = $mail_address.gsub(/\s/, "")
                $mem_1 = $mail_address
				$ff.text_field(:name, "txtEmail").set($mail_address)
                sleep 5
                $ff.text_field(:name, "txtConfirmEmail").set($mail_address)
                $ff.text_field(:name, "txtPassword").set($mail_address)
                $ff.text_field(:name, "txtConfirmPassword").set($mail_address)
                $ff.checkbox(:name, "chbTermsAndConditions").set
				sleep 1
                $code= "test string"
                puts $code
				$ff.text_field(:name,"recaptcha_response_field").set($code)
                $ff.button(:value, "Submit").click
				$ff.select_list(:name, "optAnnualHouseholdIncomeId").set($inc_level)
                $ff.select_list(:name, "optEducationLevelId").set($education)
                $ff.select_list(:name, "optEmploymentStatusId").set($employment)
                $ff.select_list(:name, "optMaritalStatusId").set($marrital_status)
                $ff.select_list(:name, "optEthnicityId").set($ethnicity)
                $ff.select_list(:name, "optNationalityId").set($origin)
                $ff.radio(:value, "N").set
                $ff.button(:value, "NEXT").click
                sleep 5
				$file_2 = File.open($qg_id_file_path)
				$qg_id = $file_2.gets
				puts $qg_id
				$file_2.close;
				puts "**** Waiting for surveys to load ****"
				sleep 30
				if($ff.contains_text($qg_id))
					puts 'Fail'   
					$myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
				else
					puts 'Pass'
					$myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
				end
				$ff.goto("p.surveyhead.com/index.php?mode=logout")
				$ff.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$myfile.print "<td class=\"td3\"><font color=\"black\">NOT COMPLETED SUCCESSFULY!{Please check the log for details}</font></td></tr>"
			end	
	  end
	  
	  def test_04_disable_setting
				
			begin	
				$st = "3"
				#$test_id = $t.to_s+"."+$st.to_s
				$test_description = "Disabled setting at QG level "
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$file_1 = File.open($proj_id_file_path)
				$prj_id = $file_1.gets
				puts $prj_id
				$file_1.close;
			
				$file_2 = File.open($qg_id_file_path)
				$qg_id = $file_2.gets
				puts $qg_id
				$file_2.close;
					
				$prj_n = Base64.encode64($prj_id)
				$qg_n = Base64.encode64($qg_id)
					
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$ie.goto("p.usampadmin.com/add_quota_group.php?project_id=#{$prj_n}&quota_group_id=#{$qg_n}")
				$ie.checkbox(:id, "chkExcludeMembers").clear
				#$ie.text_field(:id, "txtExcludeMembersHours").set($hours)
				$ie.button(:value,"Save Group").click
				if($ie.contains_text(/Quota group details have been updated successfully/))
					puts "Updated message shown"
					if($ie.checkbox(:id, "chkExcludeMembers").isSet?)
						puts 'Fail'   
						$myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
					else
						puts 'Pass'
						$myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
					end
				else
					puts "Updated message not shown"
				end
				
				$ie.link(:text,'Logout').click
				$obj.Delete_cookies
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$myfile.print "<td class=\"td3\"><font color=\"black\">NOT COMPLETED SUCCESSFULY!{Please check the log for details}</font></td></tr>"
			end	
	  end
	  
	  def test_05_check_survey_shown
	  
			begin	
				$st = "4"
				#$test_id = $t.to_s+"."+$st.to_s
				$test_description = "Survey shown when setting disabled "
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ff = $obj.Surveyhead_login($mem_1,$mem_1)
				sleep 5
				$file_2 = File.open($qg_id_file_path)
				$qg_id = $file_2.gets
				puts $qg_id
				$file_2.close;
				puts "**** Waiting for surveys to load ****"
				sleep 30
				if($ff.contains_text($qg_id))
					puts 'Pass'
					$myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
				else
					puts 'Fail'   
					$myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
				end
				$ff.goto("p.surveyhead.com/index.php?mode=logout")
				$ff.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				$myfile.print "<td class=\"td3\"><font color=\"black\">NOT COMPLETED SUCCESSFULY!{Please check the log for details}</font></td></tr>"
			end	
	  
	  end
	  
end