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
										<!--Based on the user's IZ code, select the appropriate ILLiad URL-->
										<xsl:variable name="base_url" select="document('')//xsl:variable[@name='illiad_paths']/path[@institution=$institution_code]"/>
										<!--For common types, populate the OpenURL fields with the citation data from the request-->
										<xsl:choose>
											<xsl:when test="notification_data/phys_item_display/material_type = 'Book'">
												<xsl:variable name="title" select="notification_data/phys_item_display/title"/>
												<xsl:variable name="author_first" select="substring-before(notification_data/phys_item_display/author, ',')"/>
												<xsl:variable name="author_last" select="substring-after(notification_data/phys_item_display/author, ', ')"/>
												<xsl:variable name="pub_place" select="notification_data/phys_item_display/publication_place"/>
												<xsl:variable name="publisher" select="notification_data/phys_item_display/publisher"/>
												<xsl:variable name="isbn" select="notification_data/phys_item_display/isbn"/>
												You may <a href="{normalize-space($base_url)}OpenURL?rft.isbn={$isbn}&amp;rft.volume=&amp;rft.month=&amp;rft.genre=book&amp;rft.au=&amp;rft.pub={$publisher}&amp;rft.issue=&amp;rft.place={$pub_place}&amp;rft.title={$title}&amp;rft.stitle={$title}&amp;rft.btitle={$title}&amp;rft.jtitle=&amp;rft.aufirst={$author_first}&amp;linktype=openurl&amp;rft.atitle=&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Aarticle&amp;rft.auinit1=&amp;rft.date=&amp;url_ver=Z39.88-2004&amp;rft.aulast={$author_last}&amp;rft.spage=&amp;rft.epage=&amp;rft.pmid=&amp;rfr_id=Primo">request this item</a> via Interlibrary Loan.
											</xsl:when>
											<xsl:otherwise>
												<a href="{$base_url}">You may be able to obtain this item via Interlibrary Loan.</a>
											</xsl:otherwise>
										</xsl:choose>	
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
	<!-- Need to define the reasons for cancellation that will trigger an ILL link -->
	<xsl:variable name="reasons">
   		<reason>Cannot be fulfilled</reason>
		<reason>Item is missing</reason>
		<reason>Item is needed for Course Reserves</reason>
		<reason>Items withdrawn</reason>
   		<reason>Requested material cannot be located</reason>
   		<reason>Failed to locate potential suppliers</reason>
	</xsl:variable>
	<!-- Proxied paths for ILLiad for the WRLC schools -->
	<xsl:variable name="illiad_paths">
		<path institution="01WRLC_GWA">
			https://proxygw.wrlc.org/login?url=https://gwu.illiad.oclc.org/illiad/illiad.dll/
		</path>
		<path institution="01WRLC_AMU">
			https://proxyau.wrlc.org/login?url=https://american.illiad.oclc.org/illiad/illiad.dll/
		</path>
		<path institution="01WRLC_CAA">
			https://proxycu.wrlc.org/login?url=https://cua.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GAL">
			https://proxyga.wrlc.org/login?url=https://gallaudet.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GML">

		</path>
		<path institution="01WRLC_GUNIV">

		</path>
		<path institution="01WRLC_HOW">
			https://proxyhu.wrlc.org/login?url=https://howard.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_MAR">
			https://proxymu.wrlc.org/login?url=https://marymount.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_DOC">
			https://proxydc.wrlc.org/login?url=https://udc.illiad.oclc.org/illiad/illiad.dll
		</path>
		<path institution="01WRLC_GUNIVLAW">

		</path>
		<path institution="01WRLC_AMULAW">

		</path>
		<path institution="01WRLC_GWAHLTH">

		</path>
		<path institution="01WRLC_GWALAW">

		</path>

	</xsl:variable>
</xsl:stylesheet>
