setTimeout(function() {
    var noticeElement = document.getElementById('notice');
    if (noticeElement) {
      noticeElement.style.opacity = '0';
      setTimeout(function() {
        noticeElement.style.display = 'none';
      }, 500);
    }
  }, 3000);

document.addEventListener("DOMContentLoaded", function () {
    let deleteButton = document.getElementById("delete");
    let newButton = document.getElementById("new");
    let closeButton = document.getElementById("cancelDelete");

    if (deleteButton) {
        deleteButton.addEventListener("click", function () {
            document.getElementById("deleteModal").classList.remove("hidden");
        });
    }

    if (closeButton) {
        closeButton.addEventListener("click", function () {
            document.getElementById("deleteModal").classList.add("hidden");
        });
    }
  
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
            <p class="mb-2"><strong class="text-gray-700">Name:</strong> ${data.first_name} ${data.last_name}</p>
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

function showDeleteModal(deletePath) {
    const modal = document.getElementById("deleteModal");
    const deleteFormContainer = document.getElementById("deleteFormContainer");

    const formHTML = `
    <form action="${deletePath}" method="post" class="inline">
    <input type="hidden" name="_method" value="delete">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none ml-2">
    Delete
    </button>
    </form>
    `;

    deleteFormContainer.innerHTML = formHTML;
    modal.classList.remove("hidden");
}

document.getElementById("cancelDelete").addEventListener("click", function () {
    document.getElementById("deleteModal").classList.add("hidden");
});

document.getElementById("deleteModal").addEventListener("click", function (e) {
    if (e.target === this) {
        this.classList.add("hidden");
    }
});

function showSlide() {
    event.target.closest("td")?.classList.contains("actions") &&
        event.stopPropagation();

    document.getElementById("employeeForm")
        .classList.add("show");

    const employeeForm = document
        .getElementById("employeeForm")
        .querySelector(".p-0");

    const formHTML = `
    <% if @employee.nil? %>
    <% @employee = Employee.new %>
    <% end %>
    <%= render "form", employee: @employee %>
    `;

    employeeForm.innerHTML = formHTML;
    addOverlay();
}

function closeEmployeeDetails() {
    document.getElementById("employeeForm").classList.add("translate-x-full");

    removeOverlay();
}

function addOverlay() {
    const overlay = document.createElement("div");
    overlay.id = "detailsOverlay";
    overlay.className = "fixed inset-0 bg-black bg-opacity-50 z-40";
    overlay.onclick = closeEmployeeDetails;
    document.body.appendChild(overlay);
}

function removeOverlay() {
    const overlay = document.getElementById("detailsOverlay");
    if (overlay) {
        overlay.remove();
        document.getElementById("employeeForm").classList.remove("show");
    }
}

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeEmployeeDetails();
    }
});

function closeEmployeeForm() {
    document.getElementById("employeeForm").classList.remove("show");
    removeOverlay();
}

document.getElementById("closeForm").addEventListener("click", closeEmployeeForm);

function editEmployee(employeeId) {
    event.target.closest("td")?.classList.contains("actions") &&
        event.stopPropagation();

    document
        .getElementById("employeeForm")
        .classList.add("show");

    const employeeForm = document
        .getElementById("employeeForm")
        .querySelector(".p-0");

    fetch(`/chitoge/employees/${employeeId}/edit`, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.text();
        })
        .then((formHTML) => {
            employeeForm.innerHTML = formHTML;
            addOverlay();
        })
        .catch((error) => console.error("Error fetching form:", error));
}