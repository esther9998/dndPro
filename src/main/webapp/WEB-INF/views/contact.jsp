<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

			<div class="section" data-aos="fade-up" id="section-contact">
				<div class="container">
					<div class="row section-heading justify-content-center mb-5">
						<div class="col-md-8 text-center">
							<h2 class="heading mb-3">Get In Touch</h2>
						</div>
					</div>
					<div class="row justify-content-center">
						<div class="col-md-10 p-5 form-wrap">
							<form action="#">
								<div class="row mb-4">
									<div class="form-group col-md-4">
										<label for="name" class="label">Name</label>
										<div class="form-field-icon-wrap">
											<span class="icon ion-android-person"></span> <input
												type="text" class="form-control" id="name">
										</div>
									</div>
									<div class="form-group col-md-4">
										<label for="email" class="label">Email</label>
										<div class="form-field-icon-wrap">
											<span class="icon ion-email"></span> <input type="email"
												class="form-control" id="email">
										</div>
									</div>
									<div class="form-group col-md-4">
										<label for="phone" class="label">Phone</label>
										<div class="form-field-icon-wrap">
											<span class="icon ion-android-call"></span> <input
												type="text" class="form-control" id="phone">
										</div>
									</div>

									<div class="form-group col-md-12">
										<label for="message" class="label">Message</label>
										<textarea name="message" id="message" cols="30" rows="10"
											class="form-control"></textarea>
									</div>
								</div>
								<div class="row justify-content-center">
									<div class="col-md-4">
										<input type="submit"
											class="btn btn-primary btn-outline-primary btn-block"
											value="Send Message">
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
			<!-- .section -->
