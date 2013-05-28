Name:           perl-Octopush-API
Version:        0.1
Release:        1%{?dist}

Summary:        Perl Interface to Octopush API

Group:          Development/Libraries
License:        BSD
URL:            https://github.com/rhvt/perl-Octopush-API
Source0:        http://dist.rhv.fr/Octopush-API/Octopush-API-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  perl(ExtUtils::MakeMaker)
BuildRequires:  perl(LWP::UserAgent)
BuildRequires:  perl(XML::Simple)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))


%description
This module helps user to easily execute queries against Octopush's API.


%prep
%setup -q -n Octopush-API-%{version}


%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}


%install
make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} ';'
find $RPM_BUILD_ROOT -type d -depth -exec rmdir {} 2>/dev/null ';'
chmod -R u+w $RPM_BUILD_ROOT/*


%check
make test


%files
%{perl_vendorlib}/*
%{_mandir}/man3/Octopush::API.3pm.gz


%changelog
* Tue May 28 2013 Romain Houyvet <rhvt@rhv.fr> - 0.1-1
- Initial version.
