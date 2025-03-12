setTimeout(function () {
  var noticeElement = document.getElementById('notice');
  if (noticeElement) {
    noticeElement.style.opacity = '0';
    setTimeout(function () {
      noticeElement.style.display = 'none';
    }, 500);
  }
}, 3000);

setTimeout(function () {
  var alertElement = document.getElementById('alert');
  if (alertElement) {
    alertElement.style.opacity = '0';
    setTimeout(function () {
      alertElement.style.display = 'none';
    }, 500);
  }
}, 3000);


document.addEventListener("DOMContentLoaded", function () {
  const employeeModal = document.getElementById("employeeModal");
  const closeModalButton = document.getElementById("closeModal");

  const deleteModal = document.getElementById("deleteModal");
  const cancelDeleteButton = document.getElementById("cancelDelete");
  const confirmDeleteButton = document.getElementById("confirmDelete");
  let employeeIdToDelete = null;

  function openModal() {
    employeeModal.classList.add("show"); // Add the 'show' class to trigger the animation
  }

  // Function to close the modal
  function closeModal() {
    employeeModal.classList.remove("show");
    setTimeout(() => {
      document.getElementById("modalContent").innerHTML = "";
    }, 400);
  }

  employeeModal.addEventListener("click", function (event) {
    // Check if the click target is the modal itself (background overlay)
    if (event.target === employeeModal || event.target.classList.contains("overlay")) {
      closeModal();
    }
  });

  closeModalButton.addEventListener("click", closeModal);

  // Handle row clicks to load employee details
  document.querySelectorAll("tr[data-id]").forEach((row) => {
    row.addEventListener("click", function (event) {
      if (event.target.closest(".action-buttons")) return;

      const employeeId = this.getAttribute("data-id");
      fetch(`/chitoge/employees/${employeeId}.json`)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          const modalContent = document.getElementById("modalContent");
          modalContent.innerHTML = `
            <p class="mb-2"><strong class="text-gray-700">Name:</strong> ${data.name}</p>
            <p class="mb-2"><strong class="text-gray-700">Email:</strong> ${data.email}</p>
            <p class="mb-2"><strong class="text-gray-700">Phone:</strong> ${data.phone_number}</p>
            <p class="mb-2"><strong class="text-gray-700">Job Title:</strong> ${data.job_title}</p>
            <p class="mb-2"><strong class="text-gray-700">Hire Date:</strong> ${new Date(data.hire_at).toLocaleDateString()}</p>
            <p class="mb-2"><strong class="text-gray-700">Department ID:</strong> ${data.department_id}</p>
            <p class="mb-2"><strong class="text-gray-700">Salary:</strong> $${data.salary}</p>
            <p class="mb-2"><strong class="text-gray-700">Hourly Rate:</strong> $${data.hourly_rate}</p>
          `;
          openModal();
        })
        .catch((error) => {
          console.error("Error fetching employee details:", error);
          alert("Failed to load employee details. Please try again.");
        });
    });
  });



  // Function to open the delete modal
  function openDeleteModal(employeeId) {
    employeeIdToDelete = employeeId; // Store the employee ID
    deleteModal.classList.remove("hidden");
  }

  // Function to close the modal
  function closeDeleteModal() {
    deleteModal.classList.add("hidden");
    employeeIdToDelete = null; // Reset the employee ID
  }

  // Event listener for all delete buttons
  document.querySelectorAll(".delete-button").forEach((button) => {
    button.addEventListener("click", function () {
      const employeeId = this.getAttribute("data-id");
      openDeleteModal(employeeId);
    });
  });

  cancelDeleteButton.addEventListener("click", closeDeleteModal);

  confirmDeleteButton.addEventListener("click", function (event) {
    event.preventDefault();
    console.log("Employee ID to delete:", employeeIdToDelete);

    if (employeeIdToDelete) {
      // Send a DELETE request to the server with the employee's ID
      fetch(`/chitoge/employees/${employeeIdToDelete}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
      })
        .then((response) => {
          if (response.ok) {
            return response.json();
          } else {
            throw new Error("Failed to delete the employee");
          }
        })
        .then((data) => {
          console.log(data.message);
          window.location.reload();

          const employeeRow = document.querySelector(`tr[data-id="${employeeIdToDelete}"]`);
          if (employeeRow) {
            employeeRow.remove();
          }
          closeDeleteModal();
        })
        .catch((error) => {
          console.error("Error:", error);
        });
    }
  });




});
