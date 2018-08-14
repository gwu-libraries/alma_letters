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
							<!-- <xsl:if test="notification_data/metadata/title != ''">
								<tr>
									<td>
										<b>@@title@@: </b>
										<xsl:value-of select="notification_data/metadata/title" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/journal_title != ''">
								<tr>
									<td>
										<b> @@journal_title@@: </b>
										<xsl:value-of select="notification_data/metadata/journal_title" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/author != ''">
								<tr>
									<td>
										<b> @@author@@: </b>
										<xsl:value-of select="notification_data/metadata/author" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/author_initials != ''">
								<tr>
									<td>
										<b>@@author_initials@@: </b>
										<xsl:value-of select="notification_data/metadata/author_initials" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/edition != ''">
								<tr>
									<td>
										<b> @@edition@@: </b>
										<xsl:value-of select="notification_data/metadata/edition" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/identifier != ''">
								<tr>
									<td>
										<b>@@identifier@@: </b>
										<xsl:value-of select="notification_data/metadata/identifier" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/lccn != ''">
								<tr>
									<td>
										<b> @@lccn@@: </b>
										<xsl:value-of select="notification_data/metadata/lccn" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/issn != ''">
								<tr>
									<td>
										<b>@@issn@@: </b>
										<xsl:value-of select="notification_data/metadata/issn" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/isbn != ''">
								<tr>
									<td>
										<b> @@isbn@@: </b>
										<xsl:value-of select="notification_data/metadata/isbn" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/oclc_nr != ''">
								<tr>
									<td>
										<b> @@oclc_nr@@: </b>
										<xsl:value-of select="notification_data/metadata/oclc_nr" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/doi != ''">
								<tr>
									<td>
										<b>@@doi@@: </b>
										<xsl:value-of select="notification_data/metadata/doi" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/pmid != ''">
								<tr>
									<td>
										<b> @@pmid@@: </b>
										<xsl:value-of select="notification_data/metadata/pmid" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/publisher != ''">
								<tr>
									<td>
										<b> @@publisher@@: </b>
										<xsl:value-of select="notification_data/metadata/publisher" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/publication_date != ''">
								<tr>
									<td>
										<b>@@publication_date@@: </b>
										<xsl:value-of select="notification_data/metadata/publication_date" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/place_of_publication != ''">
								<tr>
									<td>
										<b> @@place_of_publication@@: </b>
										<xsl:value-of select="notification_data/metadata/place_of_publication" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/additional_person_name != ''">
								<tr>
									<td>
										<b> @@additional_person_name@@: </b>
										<xsl:value-of select="notification_data/metadata/additional_person_name" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/source != ''">
								<tr>
									<td>
										<b>@@source@@: </b>
										<xsl:value-of select="notification_data/metadata/source" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/series_title_number != ''">
								<tr>
									<td>
										<b> @@series_title_number@@: </b>
										<xsl:value-of select="notification_data/metadata/series_title_number" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/call_number != ''">
								<tr>
									<td>
										<b> @@call_number@@: </b>
										<xsl:value-of select="notification_data/metadata/call_number" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/volume != ''">
								<tr>
									<td>
										<b>@@volume@@: </b>
										<xsl:value-of select="notification_data/metadata/volume" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/part != ''">
								<tr>
									<td>
										<b> @@part@@: </b>
										<xsl:value-of select="notification_data/metadata/part" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/chapter != ''">
								<tr>
									<td>
										<b> @@chapter@@: </b>
										<xsl:value-of select="notification_data/metadata/chapter" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/pages != ''">
								<tr>
									<td>
										<b>@@pages@@: </b>
										<xsl:value-of select="notification_data/metadata/pages" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/start_page != ''">
								<tr>
									<td>
										<b> @@start_page@@: </b>
										<xsl:value-of select="notification_data/metadata/start_page" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/end_pagee != ''">
								<tr>
									<td>
										<b> @@end_page@@: </b>
										<xsl:value-of select="notification_data/metadata/end_page" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/issue != ''">
								<tr>
									<td>
										<b>@@issue@@: </b>
										<xsl:value-of select="notification_data/metadata/issue" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="notification_data/metadata/note != ''">
								<tr>
									<td>
										<b> @@note@@: </b>
										<xsl:value-of select="notification_data/metadata/note" />
									</td>
								</tr>
							</xsl:if> -->

							<!-- Need to define the reasons for cancellation that will trigger an ILL link -->
							<xsl:variable name="reasons">
   								<reason>Cannot be fulfilled</reason>
								<reason>Item is missing</reason>
								<reason>Item is needed for Course Reserves</reason>
								<reason>Items withdrawn</reason>
   								<reason>Requested material cannot be located</reason>
							</xsl:variable>

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
									<xsl:variable name="lookup" select="document('')//xsl:variable[@name='reasons']"/>

									<xsl:variable name="cancel_reason" select="notification_data/request/status_note_display" />
									<xsl:if test="($lookup/reason=$cancel_reason) and  (notification_data/receivers/receiver/user/linked_account = 'false')">
										<xsl:choose>
											<xsl:when test="notification_data/phys_item_display/material_type = 'Book'">
												<xsl:variable name="title" select="notification_data/phys_item_display/title"/>
												<xsl:variable name="author_first" select="substring-before(notification_data/phys_item_display/author, ',')"/>
												<xsl:variable name="author_last" select="substring-after(notification_data/phys_item_display/author, ', ')"/>
												<xsl:variable name="pub_place" select="notification_data/phys_item_display/publication_place"/>
												<xsl:variable name="publisher" select="notification_data/phys_item_display/publisher"/>
												<xsl:variable name="isbn" select="notification_data/phys_item_display/isbn"/>
												You may <a href="https://proxygw.wrlc.org/login?url=https://gwu.illiad.oclc.org/illiad/illiad.dll/OpenURL?rft.isbn={$isbn}&amp;rft.volume=&amp;rft.month=&amp;rft.genre=book&amp;rft.au=Fitzgerald&amp;rft.pub={$publisher}&amp;rft.issue=&amp;rft.place={$pub_place}&amp;rft.title={$title}&amp;rft.stitle={$title}&amp;rft.btitle={$title}&amp;rft.jtitle=&amp;rft.aufirst={$author_first}&amp;linktype=openurl&amp;rft.atitle=&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Aarticle&amp;rft.auinit1=&amp;rft.date=&amp;url_ver=Z39.88-2004&amp;rft.aulast={$author_last}&amp;rft.spage=&amp;rft.epage=&amp;rft.pmid=&amp;rfr_id=Primo">request this item</a> via Interlibrary Loan.
											</xsl:when>
											<xsl:otherwise>
												<a href="https://proxygw.wrlc.org/login?url=https://gwu.illiad.oclc.org/illiad/illiad.dll">You may be able to obtain this item via Interlibrary Loan.</a>
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
</xsl:stylesheet>
