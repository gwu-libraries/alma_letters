<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="header.xsl" />
	<xsl:include href="senderReceiver.xsl" />
	<xsl:include href="mailReason.xsl" />
	<xsl:include href="footer.xsl" />
	<xsl:include href="style.xsl" />
	<xsl:include href="recordTitle.xsl" />
	<xsl:template match="/">

		<html>
			<head>
				<xsl:call-template name="generalStyle" />
			</head>
			<body>
				<xsl:attribute name="style">
				<xsl:call-template name="bodyStyleCss" /> <!-- style.xsl -->
			</xsl:attribute>
				<xsl:call-template name="head" /> <!-- header.xsl -->
				<xsl:call-template name="senderReceiver" /> <!-- SenderReceiver.xsl -->
				<xsl:call-template name="toWhomIsConcerned" /> <!-- mailReason.xsl -->

				<div class="messageArea">
					<div class="messageBody">
						<table cellspacing="0" cellpadding="5" border="0">
							<tr>
								<td>
									@@we_cancel_y_req_of@@
									<xsl:value-of select="notification_data/request/create_date" />
									@@detailed_below@@ :
								</td>
							</tr>
							<tr>
								<td>
									<xsl:call-template name="recordTitle" /> <!-- recordTitle.xsl -->
								</td>
							</tr>
							<xsl:if test="notification_data/request/start_time != ''">
								<tr>
									<td>
										<b> @@start_time@@: </b>
										<xsl:value-of select="notification_data/booking_start_time_str" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/end_time != ''">
								<tr>
									<td>
										<b> @@end_time@@: </b>
										<xsl:value-of select="notification_data/booking_end_time_str" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/request/note != ''">
								<tr>
									<td>
										<b> @@request_note@@: </b>
										<xsl:value-of select="notification_data/request/note" />
									</td>
								</tr>
							</xsl:if>
							<tr>
								<td>
									<b> @@reason_deleting_request@@: </b>
									<xsl:value-of select="notification_data/request/status_note_display" />.
								</td>
							</tr>
							<tr>
								<td>
									<!--Defines a pair of variables in order to check the given cancellation reason against the reasons we want to trigger an ILL link, displaying the link if any of those reasons are present

										Solution courtesy of https://stackoverflow.com/questions/15929538/check-text-string-against-an-array-in-if-test-->
								
									<xsl:variable name="lookup_reasons" select="document('')//xsl:variable[@name='reasons']"/>									
									<xsl:variable name="cancel_reason" select="notification_data/request/status_note_display" />
									<!--Assigns the institution's Alma code the variable $institution_code-->
									<xsl:if test="$lookup_reasons/reason=$cancel_reason">
										<xsl:variable name="institution_code">
											<xsl:choose>
												<!--Case 1: The user's IZ is different from that of the cancelling library-->
												<xsl:when test="notification_data/receivers/receiver/user/linked_account = 'true'">
													 <xsl:value-of select="notification_data/request/from_another_inst"/>
												</xsl:when>
												<!--Case 2: The user is from the same IZ-->
												<xsl:otherwise>
													<!--The IZ code of the cancelling library is embedded in a longer string that includes the library location name -->
													<xsl:value-of select="substring-before(substring-after(concat(notification_data/organization_unit/path, '.'),  '.'), '.')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<!--Based on the user's IZ code, select the appropriate ILLiad URL. Set the @activate attribute to "true" to use this functionality for a given school.-->
										<xsl:variable name="base_url" select="document('')//xsl:variable[@name='illiad_paths']/path[(@institution=$institution_code) and (@activate='true')]"/>
										<!--For common types, populate the OpenURL fields with the citation data from the request-->
										<xsl:if test="string($base_url)">
											<xsl:variable name="metadata_scope"> 
												<xsl:choose>
													<!--If the <metadata> node is present, use it-->
													<xsl:when test="boolean(notification_data/metadata/node())">
														<xsl:value-of select="'metadata'"/>
													</xsl:when>
													<xsl:otherwise>
														<!--Default to the <phys_item_display> node, which seems always to be present -->
														<xsl:value-of select="'phys_item_display'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<!--Call the template to generate the ILLiad URL-->
											<xsl:call-template name="generate_url">
												<xsl:with-param name="metadata_scope" select="$metadata_scope"/>
												<xsl:with-param name="base_url" select="$base_url"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:if> 
								</td>
							</tr>
							<xsl:if test="notification_data/request/system_notes != ''">
								<tr>
									<td>
										<b> @@request_cancellation_note@@: </b>
										<xsl:value-of select="notification_data/request/system_notes" />
									</td>
								</tr>
							</xsl:if>
						</table>
						<br />
						<table>

							<tr>
								<td>@@sincerely@@,</td>
							</tr>
							<tr>
								<td>@@department@@</td>
							</tr>

						</table>
					</div>
				</div>
				<xsl:call-template name="lastFooter" /> <!-- footer.xsl -->
				<xsl:call-template name="contactUs" />
			</body>
		</html>

	</xsl:template>
	<!-- Contains the logic for generating an ILLiad OpenURL, where appropriate -->
	<xsl:template name="generate_url">
		<xsl:param name="metadata_scope"/>
		<xsl:param name="base_url"/>
		<xsl:choose>
			<!--These are the two cases identified so far-->
			<xsl:when test="(notification_data/metadata/material_type = 'Article') or (notification_data/phys_item_display/material_type = 'Book')">
				<!--Pulls the values from the appropriate node, <metadata> where present or else <phys_item_display>-->
				<xsl:variable name="material_type" select="notification_data/*[local-name()=$metadata_scope]/material_type"/>
				<xsl:variable name="title" select="notification_data/*[local-name()=$metadata_scope]/title"/>
				<xsl:variable name="author_first" select="substring-before(notification_data/*[local-name()=$metadata_scope]/author, ',')"/>
				<xsl:variable name="author_last" select="substring-after(notification_data/*[local-name()=$metadata_scope]/author, ', ')"/>
				<xsl:variable name="pub_place" select="notification_data/*[local-name()=$metadata_scope]/publication_place"/>
				<xsl:variable name="publisher" select="notification_data/*[local-name()=$metadata_scope]/publisher"/>
				<xsl:variable name="isbn" select="notification_data/*[local-name()=$metadata_scope]/isbn"/>
				<xsl:variable name="journal_title" select="notification_data/*[local-name()=$metadata_scope]/journal_title"/>
				<xsl:variable name="volume" select="notification_data/*[local-name()=$metadata_scope]/volume"/>
				<xsl:variable name="issue" select="notification_data/*[local-name()=$metadata_scope]/issue"/>
				<xsl:variable name="start_page" select="notification_data/*[local-name()=$metadata_scope]/start_page"/>
				<xsl:variable name="end_page" select="notification_data/*[local-name()=$metadata_scope]/end_page"/>
				<xsl:variable name="publication_date" select="notification_data/*[local-name()=$metadata_scope]/publication_date"/>
				<xsl:variable name="edition" select="notification_data/*[local-name()=$metadata_scope]/edition"/>
				<xsl:variable name="issn" select="notification_data/*[local-name()=$metadata_scope]/issn"/>
				<!-- Generates an OpenURL string inside an <a> tag-->
				You may <a href="{normalize-space($base_url)}OpenURL?rft.isbn={$isbn}&amp;rft.volume={$volume}&amp;rft.month=&amp;rft.genre={$material_type}&amp;rft.au=&amp;rft.pub={$publisher}&amp;rft.issue={$issue}&amp;rft.place={$pub_place}&amp;rft.title={$title}&amp;rft.stitle={$title}&amp;rft.btitle={$title}&amp;rft.jtitle={$journal_title}&amp;rft.aufirst={$author_first}&amp;linktype=openurl&amp;rft.atitle={$title}&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Aarticle&amp;rft.auinit1=&amp;rft.date={$publication_date}&amp;url_ver=Z39.88-2004&amp;rft.aulast={$author_last}&amp;rft.spage={$start_page}&amp;rft.epage={$end_page}&amp;rft.pmid=&amp;rfr_id=Primo">request this item</a> via Interlibrary Loan.
			</xsl:when>
			<xsl:otherwise>
				<!-- Generic ILLiad URL -->
				<a href="{$base_url}">You may be able to obtain this item via Interlibrary Loan.</a>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<!-- Defines the reasons for cancellation that will trigger an ILL link -->
	<xsl:variable name="reasons">
		<reason>Item is missing</reason>
		<reason>Item is needed for Course Reserves</reason>
		<reason>Items withdrawn</reason>
   		<reason>Requested material cannot be located</reason>
   		<reason>Failed to locate potential suppliers</reason>
	</xsl:variable>
	<!-- Proxied paths for ILLiad for the WRLC schools. Set @activate to "true" to show ILLiad links for users of that school, where appropriate -->
	<xsl:variable name="illiad_paths">
		<path institution="01WRLC_GWA" activate="true">
			https://proxygw.wrlc.org/login?url=https://gwu.illiad.oclc.org/illiad/illiad.dll/
		</path>
		<path institution="01WRLC_AMU" activate="false">
			https://proxyau.wrlc.org/login?url=https://american.illiad.oclc.org/illiad/illiad.dll/
		</path>
		<path institution="01WRLC_CAA" activate="false">
			https://proxycu.wrlc.org/login?url=https://cua.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GAL" activate="false">
			https://proxyga.wrlc.org/login?url=https://gallaudet.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GML" activate="false">

		</path>
		<path institution="01WRLC_GUNIV" activate="false">

		</path>
		<path institution="01WRLC_HOW" activate="false">
			https://proxyhu.wrlc.org/login?url=https://howard.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_MAR" activate="false">
			https://proxymu.wrlc.org/login?url=https://marymount.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_DOC" activate="false">
			https://proxydc.wrlc.org/login?url=https://udc.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GUNIVLAW" activate="false">

		</path>
		<path institution="01WRLC_AMULAW" activate="false">

		</path>
		<path institution="01WRLC_GWAHLTH" activate="false">

		</path>
		<path institution="01WRLC_GWALAW" activate="false">

		</path>
	</xsl:variable>
	

</xsl:stylesheet>
