# SURVEY REDIRECTION TYPE

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
require 'Input Repository\Test_24_Survey_redirection_Input.rb'

class Test_24_Survey_redirection < Test::Unit::TestCase

			$wd=Dir.pwd
			$proj_id_file_path = $wd+"/Input Repository/Project_ID.txt"
			$qg_id_file_path = $wd+"/Input Repository/QG_ID.txt"
			$out_fl_path = $wd+"/Output Repository/Non4S_Test_Report.html"
  
      def test_01_report_head
	  
				$t = "24 - "
				$test_description = "Test Case: "+$t.to_s+"  SURVEY REDIRECTION (STANDARD/IFRAME)"
				$obj = Usamp_lib.new
				$obj.Test_report($test_description)
								
	  
	  end
	  
	  def test_02_std_red_set
	  
			begin	
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
					
				$ie.goto("p.usampadmin.com/add_quota_group.php?project_id=#{$prj_n}&quota_group_id=#{$qg_n}")
				sleep 2
				$ie.select_list(:name, "optQuotaStatus").set("Open")
				$ie.select_list(:id, "optCategory").set("Music")
				$ie.checkbox(:id, "chkShowSurvey").set
				$ie.text_field(:id, "txtSurveyName").set("REDIRECT TEST SURVEY")
				$ie.button(:value,"Save Group").click
				sleep 2
				$pub_enc_id = Base64.encode64($pub_id)
				$ie.goto("http://p.usampadmin.com/add_publisher_settings.php?hdMode=settings&publisher_id=#{$pub_enc_id}")
				$ie.checkbox(:id, "chkSurveyCategories").set
                sleep 2
                $ie.select_list(:id, "optCategoryId").set("Music")
                $ie.button(:index,"3").click
                sleep 2
                $ie.button(:value,"Save").click
				
				$enc_site_id = Base64.encode64($site_id)
                $enc_site_id = $enc_site_id.chomp
                $site_det_url = "http://p.usampadmin.com/add_site.php?site_id=#{$enc_site_id}"
                $site_det_url=$site_det_url.chomp
				$ie.goto($site_det_url)
				$ie.radio(:id, "rdExitSurveyHide").set
                $ie.radio(:name, "rbRediractionType", "standard").click
                $ie.button(:value,"Update").click
				$ie.link(:text,"Logout").click
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
			end	
			
	  end
	  
	  def test_03_exclude_4s_surveys
	  
			begin	
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$enc_site_id = Base64.encode64($site_id)
                $enc_site_id = $enc_site_id.chomp
                $site_det_url = "http://p.usampadmin.com/add_site.php?site_id=#{$enc_site_id}"
                $site_det_url=$site_det_url.chomp
				$ie.goto($site_det_url)
				sleep 3
				$ie.checkbox(:id, "cbExcludeMembersFromUsampChannel").set
				$ie.button(:value,"Update").click
				$ie.link(:text,"Logout").click
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
			end
	  end
	  
	  def test_04_std_redirection
	  
			begin
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ff = $obj.Focusline_login($m1_email,$m1_passwd)
				sleep 25
				$st = '1'
				$test_description = "Standard type survey redirection"
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				if ($ff.contains_text("REDIRECT TEST SURVEY"))
                    $ff.button(:value,"Start Survey").click
                    $ff.button(:value,"START SURVEY").click
                    sleep 7
                    $ff1=FireWatir::Firefox.attach(:title,'TEST_AUTOMATION_SURVEY')
					sleep 2
                    $ff1.goto('http://p.u-samp.com/redirect.php?S=1')
					sleep 3
                    if($ff1.contains_text("Dashboard") && $ff1.contains_text("My Rewards") && $ff1.contains_text("Logout"))
                            puts "STD:PASS"
                            $myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
                    else
                            puts "STD:FAIL"
                            $myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
                    end
                else
                    $myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED (Survey not shown)</font></td></tr>"
                    puts "FAIL** SURVEY NOT SHOWN ON DASHBOARD"
                end
				$ff1.close
				$ff.goto("http://www.sm.p.surveyhead.com/index.php?mode=logout")
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
	  
	  
	  
	  
	  def test_05_iframe_red_set
	  
			begin	
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$enc_site_id = Base64.encode64($site_id)
                $enc_site_id = $enc_site_id.chomp
                $site_det_url = "http://p.usampadmin.com/add_site.php?site_id=#{$enc_site_id}"
                $site_det_url=$site_det_url.chomp
				$ie.goto($site_det_url)
				$ie.radio(:value, "iframe").click
                $ie.button(:value,"Update").click
                sleep 2
				$ie.link(:text,"Logout").click
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
			end
		end
	  
	  def test_06_iframe_redirection
	  
			begin	
				$ff = $obj.Focusline_login($m2_email,$m2_passwd)
				sleep 25
				$st = '2'
				$test_description = "Iframe type survey redirection"
				$myfile.print "<tr><td class=\"td1\">"+$st+"</td>"
				$myfile.print "<td class=\"td2\">"+$test_description+"</td>"
				if ($ff.contains_text("REDIRECT TEST SURVEY"))
                    $ff.button(:value,"Start Survey").click
                    $ff.button(:value,"START SURVEY").click
                    sleep 7
                    $ff1=FireWatir::Firefox.attach(:title,'TEST_AUTOMATION_SURVEY')
                    $ff1.goto('http://p.u-samp.com/redirect.php?S=1')
					sleep 3
                    if($ff1.contains_text(/click here to close this window/))
                            puts "IFRM:PASS"
                            $myfile.print "<td class=\"td3\"><font color=\"green\">TEST PASSED</font></td></tr>"
                    else
                            puts "IFRM:FAIL"
                            $myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED</font></td></tr>"
                    end
                else
                    $myfile.print "<td class=\"td3\"><font color=\"red\">TEST FAILED (Survey not shown)</font></td></tr>"
                    puts "FAIL** SURVEY NOT SHOWN ON DASHBOARD"
                end
				$ff1.close
				$ff.goto("http://www.sm.p.surveyhead.com/index.php?mode=logout")
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
	
	def test_07_include_4s_surveys
	  
			begin	
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$enc_site_id = Base64.encode64($site_id)
                $enc_site_id = $enc_site_id.chomp
                $site_det_url = "http://p.usampadmin.com/add_site.php?site_id=#{$enc_site_id}"
                $site_det_url=$site_det_url.chomp
				$ie.goto($site_det_url)
				sleep 3
				$ie.checkbox(:id, "cbExcludeMembersFromUsampChannel").clear
				$ie.button(:value,"Update").click
				$ie.link(:text,"Logout").click
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
			end	
	  end

	def test_08_reset_all
				
			begin	
				$obj = Usamp_lib.new
				$obj.Delete_cookies()
				$ie = $obj.Usampadmin_login($admin_email,$admin_passwd)
				sleep 2
				$enc_site_id = Base64.encode64($site_id)
                $enc_site_id = $enc_site_id.chomp
                $site_det_url = "http://p.usampadmin.com/add_site.php?site_id=#{$enc_site_id}"
                $site_det_url=$site_det_url.chomp
				$ie.goto($site_det_url)
				
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
				$ie.goto($site_det_url)
				$ie.radio(:name, "rbRediractionType", "standard").click
                $ie.button(:value,"Update").click
				sleep 2
				$pub_enc_id = Base64.encode64($pub_id)
				$ie.goto("http://p.usampadmin.com/add_publisher_settings.php?hdMode=settings&publisher_id=#{$pub_enc_id}")
				$ie.checkbox(:id, "chkSurveyCategories").clear
                sleep 1
                $ie.button(:value,"Save").click
                sleep 2
				$ie.goto("p.usampadmin.com/add_quota_group.php?project_id=#{$prj_n}&quota_group_id=#{$qg_n}")
				sleep 2
				$ie.select_list(:name, "optQuotaStatus").set("Open")
				$ie.select_list(:id, "optCategory").set("Business")
				$ie.checkbox(:id, "chkShowSurvey").set
				$ie.text_field(:id, "txtSurveyName").set("AUTO TEST SURVEY")
				$ie.button(:value,"Save Group").click
				$ie.link(:text,"Logout").click
				$ie.close
			rescue => e
				puts e.message
				puts e.backtrace.inspect
				$obj.Close_all_windows
			end
	end

end