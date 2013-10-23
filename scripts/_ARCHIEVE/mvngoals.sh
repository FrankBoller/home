#!/bin/bash
# $Id: mvngoals.sh,v 1.3 2005/12/14 17:00:58 fboller Exp $
#############################################################################

bn=$(basename $0 .sh)
delim=$'\001'
space40="                                        ";
width=150


typeset -i E_OPTERR=0

options="hw:"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    w) width=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage
    w is the width          : $width
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

# mark begining of each line, fold ,indent (folded lines) 40 spaces, unmark
cat <<EOF | sed "s/^/${delim}/" | fold -s -w ${width} | sed -e "s/^[^${delim}]/${space40}&/" -e "s/${delim}//g"

#############################################################################
# $Id: mvngoals.sh,v 1.3 2005/12/14 17:00:58 fboller Exp $
#
# see: http://maven.apache.org/plugins/index.html
#############################################################################
ant:ant                             | A Maven2 plugin to generate an Ant build file.
antlr:generate                      | No description.
antrun:run                          | Maven AntRun Mojo. This plugin provides the capability of calling ant tasks from a POM. It is encouraged to move the actual tasks to a separate build.xml file and call that file with an <ant/> task.
archetype:create                    | Builds archetype containers.
assembly:assembly                   | Assemble an application bundle or distribution from an assembly descriptor.
assembly:directory                  | Assemble an application bundle or distribution.
assembly:unpack                     | Unpack project dependencies. Currently supports dependencies of type jar and zip.
checkstyle:checkstyle               | No description.
clean:clean                         | Goal which cleans the build.
clover:check                        | Verify test percentage coverage and fail the build if it is below the defined threshold.
clover:instrument                   | Instrument source roots.
clover:log                          | Provides information on the current Clover database.
clover:report                       | Generate a Clover report.
compiler:compile                    | No description.
compiler:testCompile                | No description.
deploy:deploy                       | Deploys an artifact to remote repository.
ear:ear                             | Builds J2EE Enteprise Archive (EAR) files.
ear:generate-application-xml        | A Mojo used to build the application.xml file.
eclipse:add-maven-repo              | A Maven2 plugin to ensure that the classpath variable MAVEN_REPO exists in the Eclipse environment.
eclipse:clean                       | A Maven2 plugin to delete the .project, .classpath and .wtpmodules files needed for Eclipse.
eclipse:eclipse                     | A Maven2 plugin which integrates the use of Maven2 with Eclipse.
ejb:ejb                             | Build an EJB (and optional client) from the current project.
idea:idea                           | Goal for generating IDEA files from a POM.
install:install-file                | Installs a file in local repository.
install:install                     | Installs project's main artifact in local repository.
jar:jar                             | Build a JAR from the current project.
jar:test-jar                        | Build a JAR of the test classes for the current project.
javadoc:jar                         | No description.
javadoc:javadoc                     | Generates documentation for the Java code in the project using the standard Javadoc Tool tool.
plugin:addPluginArtifactMetadata    | Inject any plugin-specific artifact metadata to the project's artifact, for subsequent installation and deployment. The first use-case for this is to add the LATEST metadata (which is plugin-specific) for shipping alongside the plugin's artifact.
plugin:descriptor                   | Generate a plugin descriptor.
plugin:report                       | Generates the Plugin's documentation report.
plugin:updateRegistry               | Update the user plugin registry (if it's in use) to reflect the version we're installing.
plugin:xdoc                         | No description.
pmd:pmd                             | Implement the PMD report.
project-info-reports:cim            | Generates the Project Continuous Integration System report.
project-info-reports:dependencies   | Generates the Project Dependencies report.
project-info-reports:issue-tracking | Generates the Project Issue Tracking report.
project-info-reports:license        | Generates the Project License report.
project-info-reports:mailing-list   | No description.
project-info-reports:project-team   | Generates the Project Team report.
project-info-reports:scm            | Generates the Project Source Code Management report.
projecthelp:active-profiles         | Lists the profiles which are currently active for this build.
projecthelp:describe                | No description.
projecthelp:effective-pom           | Display the effective POM for this build, with the active profiles factored in.
projecthelp:effective-settings      | Print out the calculated settings for this project, given any profile enhancement and the inheritance of the global settings into the user-level settings.
rar:rar                             | Builds J2EE Resource Adapter Archive (RAR) files.
release:perform                     | Perform a release from SCM
release:prepare                     | Prepare for a release in SCM
resources:resources                 | Copy application resources.
resources:testResources             | No description.
site:deploy                         | Deploys website using scp/file protocol. For scp protocol, website files are packaged into zip archive, then archive is transfred to remote host, nextly it is un-archived. This method of deployment should normally be much faster then making file by file copy. For file protocol, the files are copied directly to the destination directory.
site:site                           | Generates the project site.
source:jar                          | This plugin bundles all the generated sources into a jar archive.
surefire:test                       | No description.
verifier:verify                     | Verifies existence or non-existence of files/directories an optionally checks file content against a regexp.
war:exploded                        | Generate the exploded webapp
war:inplace                         | Generates webapp in the source directory
war:war                             | Build a war/webapp.
#############################################################################

EOF
