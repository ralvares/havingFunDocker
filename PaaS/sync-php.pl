#!/usr/bin/perl
use strict;
use warnings;
use File::Slurp qw(read_dir);
use File::Copy;

use feature qw(say);
my $status;
my $dir;
my $customer="CUSTOMER";
my $directory="/deploy/";


sub veriservice{
	my($dir)=@_;
	if($dir){
		open(STATUS,"systemctl status $customer\@$dir.service |") || die "Failed: $!\n";
		while ( <STATUS> ) {
  			if(/active/){
				return 1;
			}else{
				return -1;
			}
  		}
  	}
}


#sub - Create systemd service responsible for Docker container.
sub writesystemd{
	$dir = $_[0];
	if($dir){
		open(STATUS,"systemctl is-enabled $customer\@$dir.service |") || die "Failed: $!\n";
		while ( <STATUS> ) {
			if(/enabled/){
				return 1;
			}
			if(/disabled/){
				my $status = system("systemctl","stop","$customer\@$dir.service");
  				say "Desabilitando Dominio $dir [OK]";
  				return 0;
			}
  		}
  		say "Criando o servico -> $dir ...";
  		copy("/opt/datasus-PaaS/template.service","/usr/lib/systemd/system/$customer\@$dir.service") or die "Copy failed: $!";
  		system("systemctl","enable","$customer\@$dir.service");
		return 1;
  		
	}
}

#sub -> start systemd service and test if its OK.
sub startsystemd{
	$dir = $_[0];
	if($dir){
		if(veriservice($dir) != 1){
				my $status = system("systemctl","start","$customer\@$dir.service");
  				if($status == 0){
  					return 1;
  				}else{
  					say "Erro ao Iniciar o dominio -> $dir";
  				}
  		}else{
  			return 1;
  		}
	}
}

sub clean{
	open(STATUS,"systemctl list-unit-files --no-pager --no-legend $customer\@* |") || die "Failed: $!\n";
		while ( <STATUS> ) { 
			if(/$customer/){
				my @fields = split /.service/, $_;
				@fields = split /$customer\@/, $fields[0];
				if(!-d "$directory/$fields[1]"){
					say "Diretorio $fields[1] nao existe, removendo systemd services.";
					system("systemctl","stop","$customer\@$fields[1].service");
					system("systemctl","disable","$customer\@$fields[1].service");
  					unlink "/usr/lib/systemd/system/$customer\@$fields[1].service";
				}

			}
		}
}


my $root = "$directory";
for $dir (grep { -d "$root/$_" } read_dir($root)) {
	if($dir =~ /^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$/){
	if(writesystemd($dir) == 1){
		if(startsystemd($dir) == 1){
		say "Dominio $dir -> [OK]";
		}		
	}
	}else {
		say "Dominio Invalido -> $dir";
	}
}
#Manutencao -> Remove todos os dominios sem diretorio no /deploy
clean;
