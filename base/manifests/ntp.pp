#统一管理ntp.conf文件
#当ntp.conf文件有更新时，同步此文件，然后停止ntpd服务，ntpdate修正时间，启动ntpd服务
class base::ntp {
	file { "/etc/ntp.conf":
	    ensure  => "present",
	    owner   => "root",
	    group   => "root",
	    mode    => "644",
	    source  => "puppet:///modules/base/ntp.conf",
	    notify  => "Exec[systemctl stop ntpd]",
	    backup  => main,
	}
	
	exec {"systemctl stop ntpd":
            user      => "root",
            cwd       => "/tmp",
            path      => "/usr/bin:/usr/sbin:/sbin:/bin",
            provider  => "shell",
            timeout   => "60",
            refreshonly => "true",
        }
	
	exec {"ntpdate hbntp.jcloud.com":
            user      => "root",
            cwd       => "/tmp",
            path      => "/usr/bin:/usr/sbin:/sbin:/bin",
            provider  => "shell",
            timeout   => "60",
	    subscribe => "Exec[systemctl stop ntpd]",
            refreshonly => "true",
        }

	exec {"systemctl start ntpd":
	    user      => "root",
	    cwd       => "/tmp",
	    path      => "/usr/bin:/usr/sbin:/sbin:/bin",
	    provider  => "shell",
            timeout   => "60",
	    subscribe => "Exec[ntpdate hbntp.jcloud.com]",
            refreshonly => "true",
        }
}